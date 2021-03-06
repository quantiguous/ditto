class ApiController < ApplicationController
  def execute_route
    
    nonce = nil
    chained_req = nil
    chained_res = nil
    
    if request.method == "GET" || request.method == "PUT" || request.method == "DELETE"
      input_data = request.query_parameters
    elsif request.method == "POST"
      input_data = request.body.read
    end

    # we find matching routes for a SOAP (if SOAPAction is present) , and non SOAP routes in other cases
    # requests necessarily need to send a SOAPAction header. if they need to match a SOAP Route
    if request.env['HTTP_SOAPACTION'].present? and request.env['HTTP_SOAPACTION'] != '""'
      route = Route.find_by(:uri => request.path, :http_method => request.method, :kind => 'SOAP', :operation_name => request.env['HTTP_SOAPACTION'].gsub(/\"/, ""))
    end

    if route.nil?
      begin
        # the first segment cannot be a variable
        segments = request.path.split('/')
        if segments.count < 3
          # we didnt get enough segments, so we do a direct match
          route = Route.where(:uri => request.path, :http_method => request.method).where.not(:kind => 'SOAP').first
          if route.nil? && request.content_type.include?("json")
            json_req = JSON.parse(input_data)
            route = Route.find_by(:uri => request.path, :http_method => request.method, :kind => 'SOAP', :operation_name => json_req.keys.first, support_json: 'Y')
          end
        else
          # we have atleast 2 segments, the first segment is not variable
          segment_1 = '/' + segments[1] + '%'
          routes = Route.where(:http_method => request.method).where("uri LIKE ?", segment_1).where.not(:kind => 'SOAP')
          matched_routes = routes.select { |route|
            # a variable segment can have word characters and a dot
            regex = Regexp.new('^' + route.uri.gsub(/{[\w|\.]+}/,'[\w|\.|-|~|:|\?|#|\[|\]|@|!|\$|&|\'|\(|\)|\*|\+|,|;|=]+') + '$') 
            !regex.match(request.path).nil?
          }
          if matched_routes.count > 0
            route = matched_routes.first
          end
        end
      rescue
        render status: 400, text: "Bad Request."
        return
      end
    end
    
    if route.nil?
      log = {:route_id => nil, :status_code => '404', :response => nil}
      render status: 404, text: "#{request.path} not found."
    else
      if request.method != route.http_method
        log = {:route_id => route.id, :status_code => '405', :response => nil}
        render status: 405, text: "#{request.method} not allowed for #{params[:uri]} route."
      else
        if route.enforce_http_basic_auth == 'Y'
          # apply security (basic auth)
          authenticated = false
          return request_http_basic_authentication('ditto') unless request.env['HTTP_AUTHORIZATION'].present?
          authenticated = authenticate_with_http_basic do |user, password|
            authenticated = (user == route.username and password == route.password)
          end
          return request_http_basic_authentication('ditto') unless authenticated
        end
        
        req_obj = route.parse_request(input_data, request.content_type)
        
        query_params = request.query_parameters
        query_params.merge!(params.except(:controller, :action))
        
        headers = {'Accept' => request.env['HTTP_ACCEPT'], 
                   'X-QG-CI-SVC' => request.env['HTTP_X_QG_CI_SVC'], 
                   'X-QG-CI-URI' => request.env['HTTP_X_QG_CI_URI'], 
                   'X-QG-CI-SCENARIO' => request.env['HTTP_X_QG_CI_SCENARIO'],
                   'X-QG-CI-METHOD' => request.env['HTTP_X_QG_CI_METHOD'],
                   'X-QG-CI-STEP-NO' => request.env['HTTP_X_QG_CI_STEP_NO']}

        #evaluating nonce matcher
        if route.nonce_matcher.present?
          nonce_value = route.nonce_value({body: req_obj, content_type: request.content_type, headers: nil, params: query_params})
          if nonce_value.blank?
            log = {:route_id => route.id, :status_code => '400', :response => 'Bad Request, NONCE evaluation failed'}
          else
            begin
              nonce = Nonce.create!({route_id: route.id, matcher_id: route.nonce_matcher.id, nonce_value: nonce_value, created_at: Time.zone.now, expire_at: Time.zone.now + route.nonce_expire_after.minutes})
            rescue ActiveRecord::ActiveRecordError => e
              # handle duplicate 
              log = route.build_nonce_failed_reply({body: req_obj, content_type: request.content_type, headers: headers, params: query_params})
            end
          end
        end

        #evaluating chained route
        if route.chained_route.present?
          chained_nonce = Nonce.find_by(route_id: route.chained_route.id, nonce_value: route.chain_matcher.value({body: req_obj, content_type: request.content_type, headers: headers, params: query_params}))
          
          if chained_nonce.nil?  || chained_nonce.request_log.nil?
            # we have to return the response specified by chain_matcher
            log = route.build_chain_failure_reply({body: req_obj, content_type: request.content_type, headers: headers, params: query_params})
          else
            chained_call = chained_nonce.request_log
            chained_req = {
              body: route.chained_route.parse_request(chained_call.request, chained_call.content_type),
              content_type: chained_call.content_type,
              headers: [],
              params: {},
              req_datetime: formatted_date(chained_call.created_at)
            }
            chained_rep = {
              body: route.chained_route.parse_request(chained_call.response, chained_call.rep_content_type),
              content_type: chained_call.rep_content_type,
              headers: [],
              params: {}
            }
            
          end
        end
        
        #nonce/chained route evaluation failed
        if log.present?
          if log[:status_code] == '400'
            render status: 400, text: log[:response]
          else
            render status: log[:status_code], text: log[:response_text], content_type: log[:response].try(:content_type)
            log_request(request, input_data, log, nonce)
          end
          return
        end

        #evaluate matchers
        if req_obj.instance_of?(Oga::XML::Document) or ['PLAIN-TEXT', 'URL-FORM-ENCODED'].include?route.kind 
          
          log = route.build_reply({body: req_obj, content_type: request.content_type, headers: headers, params: query_params}, chained_req, chained_rep)
    
          # if a delay is expected in the response, we sleep, a maximum of 60 secs is allowed
          if (1..60).include?(request.env['HTTP_X_QG_CI_DELAY'].to_i)
            if request.env['HTTP_X_QG_CI_STEP_NO'] == request.env['HTTP_X_QG_CI_DELAY_STEP']
              sleep request.env['HTTP_X_QG_CI_DELAY'].to_i
            end
          end
    
          render status: log[:status_code], text: log[:response_text], content_type: log[:response].try(:content_type)
        else
          log = {:route_id => route.id, :status_code => '400', :response => nil}
          render status: 400, text: "Bad Request."
        end
      end
      log_request(request, input_data, log, nonce)
    end
  end
  
  private

  
  def log_request(request, input_data, log, nonce)
    # log Noonce as well as request in a single active-record transaction
    ActiveRecord::Base.transaction do
      req_log = RequestLog.new(:request => input_data)
      req_log.route_id = log[:route_id]
      req_log.response = log[:response_text]
      req_log.content_type = request.content_type
      req_log.rep_content_type = log[:response].try(:content_type)

      req_header = RequestHeader.new(input_data, request.content_type, request.method, request.env['HTTP_ACCEPT'], request.content_length)
      res_header = ResponseHeader.new(log[:response].present? ? log[:response].content_type : nil, log[:status_code], log[:response].present? ? log[:response].response : nil)
      req_log.headers << req_header
      req_log.headers << res_header
      req_log.save
      
      # update Nonce entry with req_log.id
      unless nonce.nil?
        nonce.request_log_id = req_log.id
        nonce.save!
      end
    end    
  end
  
  def formatted_date(date)
    date.try(:strftime, "%Y-%m-%dT%I:%M:%S")
  end
end
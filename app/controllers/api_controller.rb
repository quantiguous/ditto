class ApiController < ApplicationController
  def execute_route
    
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
      # the first segment cannot be a variable
      segments = request.path.split('/')
      if segments.count < 3
        # we didnt get enough segments, so we do a direct match
        route = Route.where(:uri => request.path, :http_method => request.method).where.not(:kind => 'SOAP').first
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
    end
    
    if route.nil?
      log = {:route_id => nil, :status_code => '404', :response => nil}
      render status: 404, text: "#{request.path} not found."
    else
      if request.method != route.http_method
        log = {:route_id => route.id, :status_code => '405', :response => nil}
        render status: 405, text: "#{request.method} not allowed for #{params[:uri]} route."
      else
        authorized = 'Y'
        if route.enforce_http_basic_auth == 'Y'
          # apply security (basic auth)
          authenticate_with_http_basic do |user, password|
            if user != route.username or password != route.password
              authorized = 'N'
              log = {:route_id => route.id, :status_code => '401', :response => nil}
              render status: 401, text: "Unauthorized."
              # return request_http_basic_authentication('ditto')
            end
          end
        end
        unless authorized == 'N' 
          req_obj = route.parse_request(input_data, request.content_type)
          if req_obj.instance_of?(Oga::XML::Document) or route.kind == 'PLAIN-TEXT'
            headers = {'Accept' => request.env['HTTP_ACCEPT'], 
                       'X-QG-CI-SVC' => request.env['HTTP_X_QG_CI_SVC'], 
                       'X-QG-CI-URI' => request.env['HTTP_X_QG_CI_URI'], 
                       'X-QG-CI-SCENARIO' => request.env['HTTP_X_QG_CI_SCENARIO'],
                       'X-QG-CI-METHOD' => request.env['HTTP_X_QG_CI_METHOD'],
                       'X-QG-CI-STEP-NO' => request.env['HTTP_X_QG_CI_STEP_NO']}
            log = route.build_reply(req_obj, request.content_type, headers, request.query_parameters)
      
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
      end
      req_log = RequestLog.new(:request => input_data)
      req_log.route_id = log[:route_id]
      req_log.response = log[:response_text]
      
      req_header = RequestHeader.new(input_data, request.content_type, request.method, request.env['HTTP_ACCEPT'], request.content_length)
      res_header = ResponseHeader.new(log[:response].present? ? log[:response].content_type : nil, log[:status_code], log[:response].present? ? log[:response].response : nil)
      req_log.headers << req_header
      req_log.headers << res_header
      req_log.save
    end
  end
end
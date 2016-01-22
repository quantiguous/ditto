class RoutesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :block_inactive_user!

  def index
    routes = Route.order("id desc")
    @routes_count = routes.count
    @routes = routes.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def show
    @route = Route.find(params[:id])
  end

  def new
    @route = Route.new
    @matchers = Matcher.all
  end

  def edit
    @route = Route.find(params[:id])
    @matchers = Matcher.all
  end

  def create
    @route = Route.new(route_params)
    
    matcher_ids = params[:matcher_ids]
    if matcher_ids.nil?
      flash[:alert] = "You haven't selected any Matcher!"
      redirect_to new_route_path
    else
      if !@route.valid?
        redirect_to new_route_path
      else
        @route.save!
        
        matcher_ids.each do |matcher_id|
          matcher = Matcher.find(matcher_id)
          matcher.update_attributes(:route_id => @route.id)
        end
        flash[:alert] = 'Route successfully created'
        redirect_to routes_path
      end
    end
  end

  def update
    @route = Route.find(params[:id])
    @route.attributes = params[:route]
    
    matcher_ids = params[:matcher_ids]
    if matcher_ids.nil?
      flash[:alert] = "You haven't selected any Matcher!"
      redirect_to new_route_path
    else
      if !@route.valid?
        redirect_to edit_route_path
      else
        @route.save!

        matcher_ids.each do |matcher_id|
          matcher = Matcher.find(matcher_id)
          matcher.update_attributes(:route_id => @route.id)
        end
        flash[:alert] = 'Route successfully updated'
        redirect_to routes_path
      end
    end
    rescue ActiveRecord::StaleObjectError
      @route.reload
      flash[:alert] = 'Someone edited the route the same time you did. Please re-apply your changes to the route.'
      render "edit"
  end

  def destroy
    @route.destroy
    respond_to do |format|
      format.html { redirect_to routes_url, notice: 'Route was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def execute_route
    
    if request.method == "GET" || request.method == "PUT"
      input_data = request.query_parameters
    elsif request.method == "POST"
      input_data = request.body.read
    end

    # we find matching routes for a SOAP (if SOAPAction is present) , and non SOAP routes in other cases
    # requests necessarily need to send a SOAPAction header. if they need to match a SOAP Route
    if request.env['HTTP_SOAPACTION'].present?
      route = Route.find_by(:uri => request.path, :operation_name => request.env['HTTP_SOAPACTION'].gsub(/\"/, ""))
    else
      route = Route.where(:uri => request.path).where.not(:kind => 'SOAP').first
    end
    
    if route.nil?
      log = {:route_id => nil, :status_code => '404', :response => nil}
      render status: 404, text: "#{request.path} not found."
    else
      req_log = RequestLog.new(:request => input_data)
      if request.method != route.http_method
        log = {:route_id => route.id, :status_code => '405', :response => nil}
        render status: 405, text: "#{request.method} not allowed for #{params[:uri]} route."
      else
        req_obj = route.parse_request(input_data)
        if req_obj.is_a?(Hash) and req_obj[:error].present?
          log = {:route_id => route.id, :status_code => '400', :response => nil}
          render status: 400, text: "Bad Request."
        else
          headers = {'Accept' => request.env['HTTP_ACCEPT'], 
                     'X-QG-CI-URI' => request.env['HTTP_X_QG_CI_URI'], 
                     'X-QG-CI-SCENARIO' => request.env['HTTP_X_QG_CI_SCENARIO']}
          log = route.build_reply(req_obj, request.content_type, headers)
          render status: log[:status_code], text: log[:response_text]
        end
      end
      req_log.route_id = log[:route_id]
      req_log.response = log[:response_text]
      req_header = RequestHeader.new(input_data, request.content_type, request.method, request.env['HTTP_ACCEPT'], request.content_length)
      res_header = ResponseHeader.new(log[:response].present? ? log[:response].content_type : nil, log[:status_code], log[:response].present? ? log[:response].response : nil)
      req_log.headers << req_header
      req_log.headers << res_header
      req_log.save
    end
  end

  private
    def route_params
      params.require(:route).permit(:kind, :http_method, :uri, :xml_validator_id, :operation_name)
    end

end

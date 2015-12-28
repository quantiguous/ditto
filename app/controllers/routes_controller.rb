class RoutesController < ApplicationController
  # before_filter :restrict_access

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
        redirect_to new_route_path
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
    request_method = request.env['REQUEST_METHOD']

    if request_method == "GET"
      input_data = params #request.query_parameters
    elsif request_method == "POST"
      input_data = request.body.read
    end

    route = Route.find_by(:uri => params[:uri])
    
    req_log = RequestLog.create(:request => input_data, :accept => request.env['HTTP_ACCEPT'], 
                                :http_method => request_method, :content_type => request.content_type)
    
    if route.nil?
      log = {:route_id => nil, :status_code => '404', :response => nil}
      render status: 404, text: "#{params[:uri]} not found."
    else
      if request_method != route.http_method
        log = {:route_id => route.id, :status_code => '405', :response => nil}
        render status: 405, text: "#{request_method} not allowed for #{params[:uri]} route."
      else
        req_obj = route.parse_request(input_data)
        if req_obj.is_a?(Hash) and req_obj[:error].present?
          log = {:route_id => route.id, :status_code => '400', :response => nil}
          render status: 400, text: "Bad Request."
        else
          response = route.find_matching_reply(req_obj, request.content_type, request.env['HTTP_ACCEPT'])
          if response.nil? 
            log = {:route_id => route.id, :status_code => '409', :response => nil}
            render status: 409, text: "No Response found." 
          else
            log = {:route_id => route.id, :status_code => '200', :response => response.response}
            render status: 200, text: response.response 
          end
        end
      end
    end
    req_log.update_attributes(log)
  end

  private
    def route_params
      params.require(:route).permit(:kind, :http_method, :uri)
    end

end

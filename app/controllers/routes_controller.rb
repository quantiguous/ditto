class RoutesController < ApplicationController
  
  def index
    @routes = Route.all
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
  end

  def create
    @route = Route.new(route_params)
    
    matcher_ids = params[:matcher_ids]
    if matcher_ids.nil?
      flash[:alert] = "You haven't selected any Matcher!"
      redirect_to new_route_path
    else
      if !@route.valid?
        p @route.errors
        redirect_to new_route_path
      else
        @route.save!
        matcher_ids.each do |matcher_id|
          matcher = Matcher.find(matcher_id)
          matcher.update_attributes(:route_id => @route.id)
        end
        flash[:alert] = 'Route successfully created'
        redirect_to @route
      end
    end
  end

  def update
    @route.attributes = params[:route]
    
    matcher_ids = params[:matcher_ids]
    if !@route.valid?
      render "edit"
    else
      @route.save!
      flash[:alert] = 'Route was successfully updated.'
      redirect_to @route
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
    route = Route.find_by(:uri => params[:uri])
    if route.nil?
      render status: 404, text: "#{params[:uri]} not found."
    else
      if params[:http_method] != route.http_method
        render status: 405, text: "#{params[:http_method]} not allowed for #{params[:uri]} route."
      else
        req_obj = route.parse_request(params[:input_request])
        if req_obj.is_a?(Hash) and req_obj[:error].present?
          render status: 400, text: "Bad Request."
        else
          response = route.find_matching_reply(req_obj, params[:content_type], params[:accept])
          if response.nil? 
            render status: 409, text: "No Response found." 
          else
            render status: 200, text: "OK" 
          end
        end
      end
    end
  end

  private
    def route_params
      params.require(:route).permit(:kind, :http_method, :uri)
    end
end

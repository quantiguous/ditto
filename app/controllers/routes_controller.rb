class RoutesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :block_inactive_user!

  def index
    routes = Route.order("uri, operation_name desc")
    @routes_count = routes.count
    @routes = routes.paginate(:per_page => 25, :page => params[:page]) rescue []
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
  
  def destroy
    @route = Route.find(params[:id])
    @route.destroy
    flash[:alert] = 'Route deleted successfuly'
    redirect_to routes_path
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
  

  private
    def route_params
      params.require(:route).permit(:kind, :http_method, :uri, :xml_validator_id, :operation_name, :enforce_http_basic_auth, :username, :password)
    end

end

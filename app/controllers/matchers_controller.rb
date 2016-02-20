class MatchersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  
  def index
    matchers = Matcher.order("id desc")
    
    if params[:route_id].present?
      matchers = Matcher.where(:route_id => params[:route_id])
    end
    
    @matchers_count = matchers.count
    @matchers = matchers.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def show
    @matcher = Matcher.find(params[:id])
    @matches = @matcher.matches
    @responses = @matcher.responses
  end
  
  def new
    @matcher = Matcher.new
  end
  
  def create
    @matcher = Matcher.new(matcher_params)
    
    if !@matcher.valid?
      render "new"
    else
      @matcher.save!
      flash[:alert] = 'Matcher was successfully created.'
      redirect_to @matcher
    end
  end
  
  def edit
    @matcher = Matcher.find(params[:id])
  end
  
  def update
    @matcher = Matcher.find(params[:id])
    
    @matcher.attributes = params[:matcher]
    if !@matcher.valid?
      render "edit"
    else
      @matcher.save!
      flash[:alert] = 'Matcher was successfully updated.'
      redirect_to @matcher
    end
    rescue ActiveRecord::StaleObjectError
      @matcher.reload
      flash[:alert] = 'Someone edited the matcher the same time you did. Please re-apply your changes to the matcher.'
      render "edit"
  end

  def destroy
    @matcher = Matcher.find(params[:id])
    @matcher.destroy
    flash[:alert] = 'Matcher deleted successfuly'
    redirect_to matchers_path
  end 

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def matcher_params
      params.require(:matcher).permit(:route_id, :name, :scenario, matches_attributes: [:id, :kind, :expression, :eval_criteria, :value, :_destroy], 
                                      responses_attributes: [:id, :content_type, :response, :status_code, :_destroy])
    end
end

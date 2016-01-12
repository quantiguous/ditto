class MatchersController < ApplicationController
  
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
      @bank.reload
      flash[:alert] = 'Someone edited the matcher the same time you did. Please re-apply your changes to the matcher.'
      render "edit"
  end

  def destroy
    @matcher.destroy
    respond_to do |format|
      format.html { redirect_to matchers_url, notice: 'Matcher was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def matcher_params
      params.require(:matcher).permit(:route_id, :name, :scenario, matches_attributes: [:id, :expression, :eval_criteria, :value, :_destroy], 
                                      responses_attributes: [:id, :content_type, :response, :status_code, :_destroy])
    end
end

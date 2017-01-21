class XmlValidatorsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  
  def index
    xml_validators = XmlValidator.order(:name)
    
    if params[:route_id].present?
      xml_validators = XmlValidator.where(:route_id => params[:route_id])
    end
    
    @xml_validators_count = xml_validators.count
    @xml_validators = xml_validators.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def show
    @xml_validator = XmlValidator.find(params[:id])
    # @response = @xml_validator.response
  end
  
  def new
    @xml_validator = XmlValidator.new
  end
  
  def create
    @xml_validator = XmlValidator.new(xml_validator_params)
    
    if !@xml_validator.valid?
      render "new"
    else
      @xml_validator.save!
      flash[:alert] = 'XmlValidator was successfully created.'
      redirect_to xml_validators_path
    end
  end
  
  def edit
    @xml_validator = XmlValidator.find(params[:id])
  end
  
  def update
    @xml_validator = XmlValidator.find(params[:id])
    
    @xml_validator.attributes = params[:xml_validator]
    if !@xml_validator.valid?
      render "edit"
    else
      @xml_validator.save!
      flash[:alert] = 'XmlValidator was successfully updated.'
      redirect_to xml_validators_path
    end
    rescue ActiveRecord::StaleObjectError
      @bank.reload
      flash[:alert] = 'Someone edited the xml_validator the same time you did. Please re-apply your changes to the xml_validator.'
      render "edit"
  end

  def destroy
    @xml_validator.destroy
    respond_to do |format|
      format.html { redirect_to xml_validators_url, notice: 'XmlValidator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def xml_validator_params
      params.require(:xml_validator).permit(:route_id, :name, :xml_schema, response_attributes: [:id, :content_type, :response, :_destroy])
    end
end

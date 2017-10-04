class XslsController < ApplicationController
  
  def new
    @xsl = Xsl.new
  end
  
  def create
    @xsl = Xsl.new(xsl_params)
    
    if !@xsl.valid?
      render "new"
    else
      @xsl.save!
      flash[:alert] = 'XSL was successfully created.'
      redirect_to xsls_path
    end
  end
  
  def edit
    @xsl = Xsl.find(params[:id])
  end
  
  def update
    @xsl = Xsl.find(params[:id])
    
    @xsl.attributes = params[:xsl]
    if !@xsl.valid?
      render "edit"
    else
      @xsl.save!
      flash[:alert] = 'XmlValidator was successfully updated.'
      redirect_to xsls_path
    end
    rescue ActiveRecord::StaleObjectError
      @xsl.reload
      flash[:alert] = 'Someone edited the XSL the same time you did. Please re-apply your changes to the XSL.'
      render "edit"
  end
  
  def index
    xsls = Xsl.order(:name)    
    @xsls_count = xsls.count
    @xsls = xsls.paginate(:per_page => 10, :page => params[:page]) rescue []
  end
  
  
  private
  
  def xsl_params
    params.require(:xsl).permit(:name, :xsl)
  end
end
class ServicesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :block_inactive_user!

  def index
    services = Service.order(:name)
    @services_count = services.count
    @services = services.paginate(:per_page => 25, :page => params[:page]) rescue []
  end

  def show
    @service = Service.find(params[:id])
  end  

  private
    def service_params
      params.require(:service).permit(:name)
    end

end
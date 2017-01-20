class SystemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :block_inactive_user!

  def index
    systems = System.order("id desc")
    @systems_count = systems.count
    @systems = systems.paginate(:per_page => 25, :page => params[:page]) rescue []
  end

  def show
    @system = System.find(params[:id])
  end

  def new
    @system = System.new
  end

  def edit
    @system = System.find(params[:id])
  end

  def create
    @system = System.new(system_params)
    
    if !@system.valid?
      redirect_to new_system_path
    else
      @system.save!
      flash[:alert] = 'System successfully created'
      redirect_to systems_path
    end
  end

  def update
    @system = System.find(params[:id])
    @system.attributes = params[:system]

    if !@system.valid?
      redirect_to edit_system_path
    else
      @system.save!
      flash[:alert] = 'System successfully updated'
      redirect_to systems_path
    end
    rescue ActiveRecord::StaleObjectError
      @system.reload
      flash[:alert] = 'Someone edited the system the same time you did. Please re-apply your changes to the system.'
      render "edit"
  end
  
  def destroy
    @system = System.find(params[:id])
    @system.destroy
    flash[:alert] = 'System deleted successfuly'
    redirect_to systems_path
  end 
  

  private
    def system_params
      params.require(:system).permit(:name)
    end

end
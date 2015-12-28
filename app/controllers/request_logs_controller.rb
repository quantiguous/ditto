class RequestLogsController < ApplicationController

  def index
    if !params[:route_id].present?
      @request_logs = RequestLog.all
    else
      @route = Route.find(params[:route_id]) rescue nil
      if !@route.nil?
        @request_logs = @route.request_logs
      else
        flash[:notice] = "Route with id #{params[:route_id]} doesn't exists."
        redirect_to "/"
      end
    end
  end

  def show
    @request_log = RequestLog.find(params[:id])
  end

end

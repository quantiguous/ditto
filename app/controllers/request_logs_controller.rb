class RequestLogsController < ApplicationController

  def index
    if !params[:route_id].present?
      request_logs = RequestLog.order("id desc")
    else
      @route = Route.find(params[:route_id]) rescue nil
      if !@route.nil?
        request_logs = @route.request_logs
      else
        flash[:notice] = "Route with id #{params[:route_id]} doesn't exists."
        redirect_to "/"
      end
    end
    @request_logs_count = request_logs.count
    @request_logs = request_logs.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def show
    @request_log = RequestLog.find(params[:id])
    @req_resp_details = {}
    @request_headers =  @request_log.headers
    if !@request_log.headers.nil?
      @req_resp_details = {request_details: @request_log.headers.first, response_details: @request_log.headers.last}
    end
  end

end

class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :block_inactive_user!

  include ActionView::Helpers::TextHelper
  respond_to :html, :js, :json, :xml

  def overview
  end

  def all_requests
    @requests = []
    10.times do
      @requests << {route: "paymate", created_at: "Today 1:01 PM", kind: "SOAP", content_type: "application/xml", http_method: "post", http_status_code: 200, processing_time: "200ms"}
    end
    
    # if params[:route_id].present?
    #   route = Route.find(params[:route_id])
    #   request_logs = route.request_logs
    # else
    #   request_logs = RequestLog.all
    # end

    # render :json => @requests
    # return
  end

  def requests_for_route
    @request = {route: "paymate", created_at: "Today 1:01 PM", kind: "SOAP", content_type: "application/xml", http_method: "post", http_status_code: 200, processing_time: "200ms", request: "<xml><Request></Request></xml>", response: "<xml><Request></Request></xml>"}
    # render :json => params
    # return
  end
  
end

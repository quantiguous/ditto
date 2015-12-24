class RoutesController < ApplicationController

  def execute_route
    route = Route.find_by(:uri => params[:uri])
    if route.nil?
      render status: 404, text: "#{params[:uri]} not found."
    else
      if params[:http_method] != route.http_method
        render status: 405, text: "#{params[:http_method]} not allowed for #{params[:uri]} route."
      else
        req_obj = route.parse_request(params[:input_request])
        if req_obj.is_a?(Hash) and req_obj[:error].present?
          render status: 400, text: "Bad Request."
        else
          response = route.find_matching_reply(req_obj, params[:content_type])
          if response.nil? 
            render status: 409, text: "No Response found." 
          else
            render status: 200, text: "OK" 
          end
        end
      end
    end
  end
end

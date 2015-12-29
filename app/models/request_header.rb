class RequestHeader
  attr_accessor :request, :content_type, :http_method, :accept, :content_length
  
  def initialize(request, content_type, http_method, accept, content_length)
    @request = request
    @content_type = content_type
    @http_method = http_method
    @accept = accept
    @content_length = content_length
  end
end
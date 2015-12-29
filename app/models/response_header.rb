class ResponseHeader
  attr_accessor :content_type, :status_code, :response
  
  def initialize(content_type, status_code, response)
    @content_type = content_type
    @status_code = status_code
    @response = response
  end
end
class Response < ActiveRecord::Base
  belongs_to :matcher
  
  def self.options_for_content_type
    [['text/plain','text/plain'], ['text/xml','text/xml'], ['application/json','application/json'], 
    ['application/xml','application/xml'], ['application/x-www-form-urlencoded','application/x-www-form-urlencoded']]
  end
  
  # to be changed , to pick up as per the definition
  def status_code
    @status_code || "200"
  end 
  def status_code=(newVal)
    @status_code = newVal
  end
end

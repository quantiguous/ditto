class Response < ActiveRecord::Base
  belongs_to :matcher
  
  before_save :set_status_code
  
  def self.options_for_content_type
    [['text/plain','text/plain'], ['text/xml','text/xml'], ['application/json','application/json'], 
    ['application/xml','application/xml'], ['application/x-www-form-urlencoded','application/x-www-form-urlencoded']]
  end
  
  # to be changed , to pick up as per the definition
  # def status_code
  #   @status_code || "200"
  # end
  # def status_code=(newVal)
  #   @status_code = newVal
  # end
  
  def set_status_code
    if self.status_code.nil?
      self.status_code = "200"
    end
  end
end

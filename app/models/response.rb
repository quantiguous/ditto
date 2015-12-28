class Response < ActiveRecord::Base
  belongs_to :matcher
  
  def self.options_for_content_type
    [['text/plain','text/plain'], ['text/xml','text/xml'], ['application/json','application/json'], 
    ['application/xml','application/xml'], ['application/x-www-form-urlencoded','application/x-www-form-urlencoded']]
  end
end

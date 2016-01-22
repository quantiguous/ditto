class Response < ActiveRecord::Base
  belongs_to :matcher
  
  before_save :set_status_code
  
  validate :validate_response_body_for_content_type
  
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
  
  def validate_response_body_for_content_type
    if ContentType.is_xml(self.content_type)
      Ox.parse(self.response)
    end
    if ContentType.is_json(self.content_type)
      xml_str = Gyoku.xml(Oj.load(self.response))
      Ox.parse(xml_str)
    end
  rescue
    errors.add(:response, "content is not valid for the content_type")
  end 
end

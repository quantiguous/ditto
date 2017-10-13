class Response < ActiveRecord::Base
  KIND = [['Response Body','response_body'], ['XSL','xsl'], ['SOAP Fault','soap_fault']]
  belongs_to :matcher
  belongs_to :xsl
  
  before_save :set_status_code
  
  validate :validate_response_body_for_content_type
  
  validates_absence_of :fault_reason, if: "fault_code.blank?", message: 'must be blank when Fault Code is blank'
  validates_presence_of :fault_reason, if: "fault_code.present?", message: 'must be present when Fault Code is present'
  
  validate :check_response_kind
  
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
  
  def check_response_kind
    if ((response.present? && (xsl_id.present? || fault_code.present? || fault_reason.present?)) ||
      (xsl_id.present? && (response.present? || fault_code.present? || fault_reason.present?)) ||
      (fault_code.present? && (xsl_id.present? || response.present?)))
      errors[:base] << "Please set either a Response, XSL or Fault Code"
    end
  end
end

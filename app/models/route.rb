class Route < ActiveRecord::Base
  has_many :matchers
  has_many :request_logs
  
  has_one :xml_validator, dependent: :destroy
  
  attr_accessor :schema_validator

  validates_presence_of :uri, :kind, :http_method
  
  def self.options_for_kind
    [['SOAP','SOAP'],['JSON','JSON']]
  end
  
  def self.options_for_http_method
    [['GET','GET'],['POST','POST'],['PUT','PUT'],['PATCH','PATCH'],['DELETE','DELETE']]
  end

  def parse_request(req)
    if self.kind == "SOAP"
      begin
        document = Oga.parse_xml(req, :strict => true)
        return document
      rescue Exception => e
        return {error: e.message}
      end
    else
      begin
        xml_str = Gyoku.xml(req)
        document = Oga.parse_xml(xml_str)
        return document
      rescue Exception => e
        return {error: e.message}
      end
    end
  end
  
  def build_reply(req_doc, content_type, accept)
    # we run the xml validator , if its defined 
    if xml_validator && !xml_validator.evaluate(req_doc.to_xml)
      # the schema validation failed, we return the return
      return xml_validator.build_reply(self.id)
    end
    
    response = find_matching_reply(req_doc, content_type, accept)
    if response.nil? 
      return {:route_id => self.id, :status_code => '409', :response => nil, :response_text => "No Response found." }
    # elsif response.is_a?(Hash) and response[:error].present?
    #   return {:route_id => self.id, :status_code => '500', :response => nil, :response_text => "Schema validation error : #{response[:error]}" }
    else
      return {:route_id => self.id, :status_code => '200', :response => response, :response_text => response.response}
    end  
  end 
  
  
  private
  
  def find_matching_reply(req_doc, content_type, accept)
    unless self.matchers.empty?
      matched = false
      self.matchers.each_with_index do |matcher, index|
        if matcher.evaluate(req_doc) 
          matched = true
          response = matcher.find_response(content_type, accept)
          return response
        end
      end
      
      if matched == false
        if !accept.nil?
          accept = accept.split(",")
          res = nil
          accept.each do |acc|
            res = self.matchers.first.responses.find_by(:content_type => acc)
          end          
          res = self.matchers.first.responses.first if res.nil?
        elsif (accept.nil?) and (content_type.present?) 
          res = self.matchers.first.responses.find_by(:content_type => content_type)
          res = self.matchers.first.responses.first if res.nil?
        else
          res = self.matchers.first.responses.first
        end
        return res
      end
    end
  end

end

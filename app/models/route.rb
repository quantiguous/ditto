class Route < ActiveRecord::Base
  has_many :matchers
  has_many :request_logs
  
  has_one :xml_validator, dependent: :destroy
  
  attr_accessor :schema_validator

  validates_presence_of :uri, :kind, :http_method
  
  def self.options_for_kind
    [['SOAP','SOAP'],['XML','XML'],['JSON','JSON'],['PLAIN-TEXT','PLAIN-TEXT']]
  end
  
  def self.options_for_http_method
    [['GET','GET'],['POST','POST'],['PUT','PUT'],['PATCH','PATCH'],['DELETE','DELETE']]
  end

  

  def parse_request(req, content_type)

    # parsing of query_params is not yet supported
    if req.empty? 
      return Oga.parse_xml('<todo/>')
    end
    
    parsed_application_type = content_type.split("/").first
    parsed_content_type = content_type.split("/").last
    
    if (parsed_application_type == "application")
      if (parsed_content_type.include?("soap") == true) || (parsed_content_type.include?("xml") == true) 
        begin
          document = Oga.parse_xml(req, :strict => true)
          return document
        rescue Exception => e
          return {error: e.message}
        end
      elsif (parsed_content_type.include?("json") == true)
        begin
          xml_str = Gyoku.xml(Oj.load(req))
          document = Oga.parse_xml(xml_str)
          return document
        rescue Exception => e
          return {error: e.message}
        end
      end
    else
      return req
    end
  end
  
  def build_reply(req_doc, content_type, headers)
    # we run the xml validator , if its defined 
    if xml_validator && !xml_validator.evaluate(req_doc.to_xml)
      # the schema validation failed, we return the return
      return xml_validator.build_reply(self.id)
    end
    
    response = find_matching_reply(req_doc, content_type, headers)
    if response.nil? 
      return {:route_id => self.id, :status_code => '501', :response => nil, :response_text => "No Response found." }
    # elsif response.is_a?(Hash) and response[:error].present?
    #   return {:route_id => self.id, :status_code => '500', :response => nil, :response_text => "Schema validation error : #{response[:error]}" }
    else
      return {:route_id => self.id, :status_code => response.status_code, :response => response, :response_text => Liquid::Template.parse(response.response).render}
    end  
  end 
  
  
  private
  
  def find_matching_reply(req_doc, content_type, headers)
    unless self.matchers.empty?
      matched = false
      accept = headers['Accept']
      
      # the list of matchers that matched
      matched_matchers = []
      
      self.matchers.each_with_index do |matcher, index|
        if matcher.evaluate(content_type, req_doc, headers) 
          matched_matchers << matcher
          matched = true
        end
      end

      # when we have a list of matched matchers, we choose the most selective one
      # a select matcher is one, that has the maximum number of 'matches' or 'rules'
      # when there are is more than one matcher with the same number of 'rules', we pick a random matcher
      # a better way would be to assign priority to the type of match ( headers have a different priority than the body )
      if matched == true
        sorted_asc_matchers = matched_matchers.sort{|left,right| left.matches.size <=> right.matches.size}
        response = sorted_asc_matchers.last.find_response(content_type, accept)
        return response
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



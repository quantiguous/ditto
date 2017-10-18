class Route < ActiveRecord::Base
  has_many :matchers
  has_many :request_logs
  
  belongs_to :xml_validator
  belongs_to :system
  
  validates_presence_of :uri, :kind, :http_method
  
  def self.options_for_kind
    [['SOAP','SOAP'],['XML','XML'],['JSON','JSON'],['PLAIN-TEXT','PLAIN-TEXT'],['URL-FORM-ENCODED','URL-FORM-ENCODED']]
  end
  
  def self.options_for_http_method
    [['GET','GET'],['POST','POST'],['PUT','PUT'],['PATCH','PATCH'],['DELETE','DELETE']]
  end

  def is_editable?
    hidden == false ? true : false
  end
  

#  def parse_request(params, req, content_type)
  def parse_request(req, content_type)
    xml_1 = ::Builder::XmlMarkup.new
    def xml_1._escape(text)
      "<![CDATA[#{text}]]>"
    end

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
      elsif (parsed_content_type.include?("x-www-form-urlencoded") == true)
        begin
          document = Oga.parse_xml(xml_1.params(params))
          return document
        rescue Exception => e
          return {error: e.message}
        end
      end
    end
    return Oga.parse_xml('<todo/>')
  end
  
  def build_reply(req_doc, content_type, headers, query_params)
    # we run the xml validator , if its defined 
    if xml_validator && !xml_validator.evaluate(req_doc.to_xml)
      # the schema validation failed, we return the return
      return xml_validator.build_reply(self.id)
    end

    response = find_matching_reply(req_doc, content_type, headers, query_params)
    if response.nil? 
      return {:route_id => self.id, :status_code => '501', :response => nil, :response_text => "No Response found." }
    # elsif response.is_a?(Hash) and response[:error].present?
    #   return {:route_id => self.id, :status_code => '500', :response => nil, :response_text => "Schema validation error : #{response[:error]}" }
    else
      begin
        return response.to_hash(self.id, req_doc, query_params)
      rescue Exception => e
        return {:route_id => self.id, :status_code => '505', :response => nil, :response_text => "Failed In Building Response #{e.message}" }
      end
    end
  end
  
  
  private
  
  def find_matching_reply(req_doc, content_type, headers, query_params)
    unless self.matchers.empty?
      matched = false
      accept = headers['Accept']
      
      # the list of matchers that matched
      matched_matchers = []
      
      self.matchers.each_with_index do |matcher, index|
        if matcher.evaluate(content_type, req_doc, headers, query_params) 
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
      
      # if no match is found, then we use the first matcher
#      if matched == false
#        return self.matchers.first.find_response(content_type, accept)
#      end
    end
  end

end



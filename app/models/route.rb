class Route < ActiveRecord::Base
  has_many :matchers

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

  def find_matching_reply(req_doc, content_type)
    unless self.matchers.empty?
      self.matchers.each do |matcher|
        if matcher.evaluate(req_doc) 
          response = matcher.find_response(content_type)
          return response
        end
      end
    end
  end

end

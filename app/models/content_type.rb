class ContentType
  def self.is_xml(content_type)
    return content_type.include?('xml') || content_type.include?('soap')
  end
  
  def self.is_json(content_type)
    return content_type.include?('json')
  end
  
  def self.is_plain(content_type)
    return content_type.include?('plain')
  end
  
  def self.is_form_urlencoded(content_type)
    return content_type.include?('x-www-form-urlencoded')
  end
end
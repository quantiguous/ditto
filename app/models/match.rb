class Match < ActiveRecord::Base
  belongs_to :matcher
  
  def self.options_for_eval_criteria
    [['Exists','exists'], ['Equal To','equal_to'], ['Starts With','starts_with'], ['Contains','contains'], ['Ends With','ends_with']]
  end
  
  def self.options_for_kind
    [['Body','body'],['Header','header'],['Query Parameter','query']]
  end
  
  def apply_expression(content_type, reqTextOrxmlDocObj, headers, query_params)
    requestString = nil
    case self.kind
    when "body"
      if ContentType.is_plain(content_type)
        requestString = reqTextOrxmlDocObj
      end
      if ContentType.is_xml(content_type) || ContentType.is_json(content_type) 
        requestString = reqTextOrxmlDocObj.xpath(self.expression).try(:text)
      end
    when "header"
      requestString = headers["#{self.expression}".upcase]
    when "query"
      requestString = query_params["#{self.expression}"]
    end
    requestString
  end  
  


  def evaluate(content_type, req, headers, query_params)
    expressionResult = apply_expression(content_type, req, headers, query_params)
    
    case self.eval_criteria
    when "exists"
      return true if expressionResult.present?

    when "equal_to"
      if (self.value.present? and expressionResult.present? and expressionResult.casecmp(self.value) == 0) or 
         (self.value.nil? and expressionResult == "")
        return true
      end
    # when "header_equal_to"
    #   if expressionResult.present? && expressionResult.casecmp(self.value) == 0
    #     return true
    #   end
    when "starts_with" , "contains", "ends_with"
      return false if expressionResult.nil?
      
      if expressionResult.present?
        if (self.eval_criteria == "starts_with" and expressionResult.upcase.starts_with?(self.value.upcase)) or
          (self.eval_criteria == "contains" and expressionResult.upcase.include?(self.value.upcase)) or
          (self.eval_criteria == "ends_with" and expressionResult.upcase.ends_with?(self.value.upcase))
          return true
        end 
      end 
    end
    
    return false
  end  
  
end

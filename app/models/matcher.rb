class Matcher < ActiveRecord::Base
  has_many :matches
  has_many :responses

  def evaluate(req)
    matched = nil
    self.matches.each do |match| 
      case match.eval_criteria
      when "exists"
        if req.xpath(match.expression).present?
          matched = true
        else
          return false
        end
      when "equal_to"
        if req.xpath(match.expression).text == match.value
          matched = true
        else
          return false
        end
      end
    end
    matched.nil? ? false : true
  end

  def find_response(content_type)
    if content_type.nil? 
      res = self.responses.first
    else 
      res = self.responses.find_by(:content_type => content_type)
    end
    return res
  end

end

class Matcher < ActiveRecord::Base
  belongs_to :route
  has_many :matches, dependent: :destroy
  accepts_nested_attributes_for :matches, :allow_destroy => true
  
  has_many :responses, dependent: :destroy
  accepts_nested_attributes_for :responses, :allow_destroy => true
  
  scope :nonce_matchers, -> { where(matcher_type: 'NONCE') }
  scope :chain_matchers, -> { where(matcher_type: 'CHAIN') }

  validates_presence_of :name
  # validate :presence_of_rules_and_responses
  
  def self.options_for_type
    [['Matcher','Matcher'], ['NONCE','NONCE'], ['CHAINED','CHAINED']]
  end
  
  def presence_of_rules_and_responses
    if self.matches.empty? or self.responses.empty?
      errors[:base] << "Matcher should have at least one Rule and Response!"
    end
  end
  
  def value(req)
    
    exp_value = nil
    
    self.matches.each_with_index do |match, index|
      match_expression_value = match.apply_expression(req[:content_type], req[:body], req[:headers], req[:params])
      if match_expression_value.nil?
        return nil
      else
        exp_value = "#{exp_value}-" unless exp_value.nil?        
        exp_value = "#{exp_value}#{match_expression_value}"
      end
    end
    
    return exp_value
  end
  
  def evaluate(req, chained_req, chained_rep)
    matched = nil
    self.matches.each_with_index do |match, index|
      case match.apply_on
      when 'REQUEST'
        return false if match.evaluate(req[:content_type], req[:body], req[:headers], req[:params]) == false 
      when 'CHAINED-REQUEST'
        return false if match.evaluate(chained_req[:content_type], chained_req[:body], chained_req[:headers], chained_req[:params]) == false
      when 'CHAINED-RESPONSE'
        return false if match.evaluate(chained_rep[:content_type], chained_rep[:body], chained_rep[:headers], chained_rep[:params]) == false
      else
        raise 'booboo'
      end

      matched = true 
    end
    
    matched.nil? ? false : true
  end

  def find_response(req)
    if !req[:accept].nil?
      accept = req[:headers]['Accept'].split(",")
      res = nil
      accept.each do |acc|
        res = self.responses.find_by(:content_type => acc)
      end
      res = self.responses.first if res.nil?
    elsif (accept.nil?) and (req[:content_type].present?) 
      res = self.responses.find_by(:content_type => req[:content_type])
      res = self.responses.first if res.nil?
    else
      res = self.responses.first
    end
    return res
  end  

end

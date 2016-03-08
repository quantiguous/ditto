class Matcher < ActiveRecord::Base
  belongs_to :route
  has_many :matches, dependent: :destroy
  accepts_nested_attributes_for :matches, :allow_destroy => true
  
  has_many :responses, dependent: :destroy
  accepts_nested_attributes_for :responses, :allow_destroy => true
  
  validates_presence_of :name
  # validate :presence_of_rules_and_responses
  
  def presence_of_rules_and_responses
    if self.matches.empty? or self.responses.empty?
      errors[:base] << "Matcher should have at least one Rule and Response!"
    end
  end
  
  def evaluate(content_type, req, headers, query_params)
    matched = nil
    self.matches.each_with_index do |match, index|
      return false if match.evaluate(content_type, req, headers, query_params) == false 
      matched = true 
    end
    
    matched.nil? ? false : true
  end

  def find_response(content_type, accept)
    if !accept.nil?
      accept = accept.split(",")
      res = nil
      accept.each do |acc|
        res = self.responses.find_by(:content_type => acc)
      end
      res = self.responses.first if res.nil?
    elsif (accept.nil?) and (content_type.present?) 
      res = self.responses.find_by(:content_type => content_type)
      res = self.responses.first if res.nil?
    else
      res = self.responses.first
    end
    return res
  end  

end

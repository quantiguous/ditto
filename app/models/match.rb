class Match < ActiveRecord::Base
  belongs_to :matcher
  
  def self.options_for_eval_criteria
    [['Exists','exists'], ['Equal To','equal_to'], ['Header Equal To','header_equal_to'], ['Starts With','starts_with']]
  end
end

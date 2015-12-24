class Match < ActiveRecord::Base
  belongs_to :matcher
  has_one :response
end

class Matcher < ActiveRecord::Base
  has_many :matches
  has_many :responses
end

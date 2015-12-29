class RequestLog < ActiveRecord::Base
  belongs_to :route
  
  serialize :headers, Array
end

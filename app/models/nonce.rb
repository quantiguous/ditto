class Nonce < ActiveRecord::Base
  has_one :request_log, primary_key: 'request_log_id', foreign_key: 'id', class_name: 'RequestLog'
end
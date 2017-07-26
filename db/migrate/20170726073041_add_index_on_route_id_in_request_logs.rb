class AddIndexOnRouteIdInRequestLogs < ActiveRecord::Migration
  def change
    add_index :request_logs, :route_id, name: 'request_logs_01' unless index_exists?(:request_logs, :route_id, name: "request_logs_01")
  end
end

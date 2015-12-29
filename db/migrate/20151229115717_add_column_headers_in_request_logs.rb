class AddColumnHeadersInRequestLogs < ActiveRecord::Migration
  def change
    add_column :request_logs, :headers, :text
  end
end

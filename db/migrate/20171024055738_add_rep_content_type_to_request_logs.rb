class AddRepContentTypeToRequestLogs < ActiveRecord::Migration
  def change
    add_column :request_logs, :rep_content_type, :string, limit: 100
  end
end

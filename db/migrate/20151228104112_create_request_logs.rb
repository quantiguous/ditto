class CreateRequestLogs < ActiveRecord::Migration
  def change
    create_table :request_logs do |t|
      t.string :route_id
      t.text :request
      t.string :status_code
      t.string :accept
      t.string :http_method
      t.string :content_type
      t.string :kind
      t.text :response
      t.timestamps null: false
    end
  end
end

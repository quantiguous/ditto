class AddColumnKindToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :kind, :string, limit: 100, null: false, default: 'response_body'
  end
end

class AddColumnStatusCodeToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :status_code, :string
  end
end

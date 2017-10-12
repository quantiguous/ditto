class AddFaultColumnsToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :fault_code, :string, limit: 100
    add_column :responses, :fault_reason, :string, limit: 400
  end
end

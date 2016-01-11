class AddColumnOperationNameToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :operation_name, :string
  end
end

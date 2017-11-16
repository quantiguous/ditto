class AddSupportJsonColumnToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :support_json, :string, limit: 1
  end
end

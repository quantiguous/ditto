class AddAuthColumnsToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :enforce_http_basic_auth, :string, :limit => 1
    add_column :routes, :username, :string, :limit => 50
    add_column :routes, :password, :string, :limit => 100
  end
end

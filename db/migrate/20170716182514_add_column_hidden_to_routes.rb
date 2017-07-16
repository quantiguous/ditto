class AddColumnHiddenToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :hidden, :boolean, :default => false, :comment => 'the flag to indicate whether the route is editable or not'
  end
end

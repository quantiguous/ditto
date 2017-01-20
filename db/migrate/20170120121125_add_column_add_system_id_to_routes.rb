class AddColumnAddSystemIdToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :system_id, :integer
    s = System.create(name: 'Miscellaneous')
    Route.update_all(system_id: s.id)
    change_column :routes, :system_id, :integer, null: false
  end
end

class CreateMatchers < ActiveRecord::Migration
  def change
    create_table :matchers do |t|
      t.integer :route_id, :comment => "the id of the route corresponding to this matcher"
      t.timestamps null: false
    end
  end
end

class AddNameInMatchers < ActiveRecord::Migration
  def change
    add_column :matchers, :name, :string
  end
end

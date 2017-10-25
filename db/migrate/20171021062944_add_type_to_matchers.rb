class AddTypeToMatchers < ActiveRecord::Migration
  def change
    add_column :matchers, :matcher_type, :string, null: false, default: 'Matcher'
  end
end

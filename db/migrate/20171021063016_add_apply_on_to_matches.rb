class AddApplyOnToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :apply_on, :string, null: false, default: 'REQUEST'
  end
end

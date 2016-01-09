class AddNameInXmlValidators < ActiveRecord::Migration
  def change
    add_column :xml_validators, :name, :string
    add_index :xml_validators, :name, :unique => true
  end
end

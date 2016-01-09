class CreateXmlValidators < ActiveRecord::Migration
  def change
    create_table :xml_validators do |t|
      t.text :xml_schema
      t.integer :matcher_id
    end
  end
end

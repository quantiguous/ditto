class AddXmlSchemaValidatorToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :xml_validator_id, :integer
  end
end

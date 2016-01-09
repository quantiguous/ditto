class AddColumnXmlValidatorIdInResponses < ActiveRecord::Migration
  def change
    add_column :responses, :xml_validator_id, :integer
  end
end

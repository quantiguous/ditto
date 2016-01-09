class ChangeColumnInXmlValidators < ActiveRecord::Migration
  def change
    rename_column :xml_validators, :matcher_id, :route_id
  end
end

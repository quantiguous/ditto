class AddColumnXslOnToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :xsl_on_kind, :string
    add_column :responses, :xsl_on_value, :string
  end
end

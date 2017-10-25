class AddXslParamsToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :xsl_params, :string
  end
end

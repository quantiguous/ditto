class AddXslIdToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :xsl_id, :integer
  end
end

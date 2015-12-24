class AddMatchIdToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :match_id, :integer, :comment => "the id of the corresponding response"
  end
end

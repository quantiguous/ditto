class AddColumnMatcherIdInResponses < ActiveRecord::Migration
  def change
    add_column :responses, :matcher_id, :integer
  end
end

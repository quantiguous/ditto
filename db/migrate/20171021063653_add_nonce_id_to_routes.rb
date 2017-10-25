class AddNonceIdToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :nonce_matcher_id, :integer, null: true
  end
end

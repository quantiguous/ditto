class AddNonceExpireAfterToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :nonce_expire_after, :integer
  end
end

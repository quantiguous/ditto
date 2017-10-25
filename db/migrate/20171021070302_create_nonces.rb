class CreateNonces < ActiveRecord::Migration
  def change
    create_table :nonces do |t|
      t.integer :route_id, null: false, comment: 'the route for which this record has been created'
      t.integer :matcher_id, null: false, comment: 'the matcher that was evaluated to determine the nonce value'
      t.string :nonce_value, null: false, comment: 'the nonce value for the request'      
      t.datetime :created_at, null: false, comment: 'the datetime when the nonce value recorded'
      t.datetime :expire_at, null: false, comment: 'the datetime when the nonce value will expire and removed'
      t.integer :request_log_id, comment: 'the request that created this nonce'
      
      t.index([:route_id, :nonce_value], unique: true, name: 'uk_nonces_1')
    end
  end
end

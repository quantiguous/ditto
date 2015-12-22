class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.text :response, :comment => "the response clob"
      t.string :content_type, :comment => "this describes the nature of the data contained in the response body"
      t.timestamps null: false
    end
  end
end

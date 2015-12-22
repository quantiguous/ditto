class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :uri, :null => false, :comment => "the url of the service which the user wants to access"
      t.string :kind, :comment => "the web service type of the request"
      t.string :http_method, :comment => "the http method for the request"
      t.timestamps null: false
    end
  end
end

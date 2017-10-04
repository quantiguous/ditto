class CreateXsls < ActiveRecord::Migration
  def change
    create_table :xsls do |t|
      t.string :name, null: false, limit: 100
      t.text :xsl, null: false
    end
  end
end

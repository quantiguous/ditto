class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.string :scenario, limit: 255, null: false
      t.integer :service_id, null: false
      t.text :request, null: false
      t.timestamps null: false
    end
  end
end

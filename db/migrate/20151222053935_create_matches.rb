class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :expression, :comment => "the xpath expression"
      t.string :value, :comment => "the value of the xpath expression"
      t.string :eval_criteria, :comment => "the evaluation criteria for the expression i.e, exixts or equal_to"
      t.integer :matcher_id, :comment => "the id of the corresponding matcher"
      t.integer :response_id, :comment => "the id of the corresponding response"
      t.timestamps null: false
    end
  end
end

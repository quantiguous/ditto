class AddScenarioToMatchers < ActiveRecord::Migration
  def change
    add_column :matchers, :scenario, :string
  end
end

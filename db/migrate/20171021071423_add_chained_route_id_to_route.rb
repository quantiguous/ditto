class AddChainedRouteIdToRoute < ActiveRecord::Migration
  def change
    add_column :routes, :chained_route_id, :integer, null: true, comment: 'the chained route if any'
    add_column :routes, :chain_matcher_id, :integer, null: true, comment: 'the matcher to be used to extract the values to be used to search for a chained request'
  end
end

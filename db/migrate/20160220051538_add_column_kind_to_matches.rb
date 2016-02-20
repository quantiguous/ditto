class AddColumnKindToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :kind, :string, :comment => "the kind of the match based on which expression will be applied"
    Match.where.not(:eval_criteria => "header_equal_to").update_all(:kind => "body")
    Match.where(:eval_criteria => "header_equal_to").update_all(:kind => "header", :eval_criteria => "equal_to")
  end
end

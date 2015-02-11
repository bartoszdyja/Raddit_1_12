class RemoveCachedVotesScoreFromLinks < ActiveRecord::Migration
    def up
    remove_column :links, :cached_votes_score
  end

  def down
    add_column :link, :cached_votes_score, :integer
  end
end

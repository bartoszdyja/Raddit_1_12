class AddCachedVotesScoreToLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :cached_votes_score, :integer, :default => 0
    add_index  :links, :cached_votes_score
    Link.find_each(&:update_cached_votes)
  end

  def self.down
    remove_column :links, :cached_votes_score
  end
end

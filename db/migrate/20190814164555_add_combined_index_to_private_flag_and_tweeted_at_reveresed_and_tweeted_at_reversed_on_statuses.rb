class AddCombinedIndexToPrivateFlagAndTweetedAtReveresedAndTweetedAtReversedOnStatuses < ActiveRecord::Migration[5.2]
  def change
    add_index :statuses, [:private_flag, :tweeted_at_reversed, :tweet_id_reversed], name: :index_statuses_for_public_timeline
  end
end

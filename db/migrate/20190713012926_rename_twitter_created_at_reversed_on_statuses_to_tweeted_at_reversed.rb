class RenameTwitterCreatedAtReversedOnStatusesToTweetedAtReversed < ActiveRecord::Migration[5.2]
  def change
    rename_column :statuses, :twitter_created_at_reversed, :tweeted_at_reversed
  end
end

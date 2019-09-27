class RenameTwitterCreatedAtOnStatusesToTweetedAt < ActiveRecord::Migration[5.2]
  def change
    rename_column :statuses, :twitter_created_at, :tweeted_at
  end
end

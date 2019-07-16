class AddUniqueIndexToTweetIdOnStatuses < ActiveRecord::Migration[5.2]
  def change
    add_index :statuses, :tweet_id, unique: true
  end
end

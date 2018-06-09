class AddIndexToTweetedOnOnStatuses < ActiveRecord::Migration[5.0]
  def change
    add_index :statuses, [:deleted, :private, :tweeted_on]
  end
end

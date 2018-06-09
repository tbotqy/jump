class AddIndexToTweetedOnOnStatuses < ActiveRecord::Migration[5.0]
  def change
    add_index :statuses, [:tweeted_on, :deleted, :private]
  end
end

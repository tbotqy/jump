class AddCombinedIndexToPrivateFlagAndTweetedOnOnStatuses < ActiveRecord::Migration[5.2]
  def change
    add_index :statuses, [:tweeted_on, :private_flag]
  end
end

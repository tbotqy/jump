class AddCombinedIndexToPrivateFlagAndTimestampOnStatuses < ActiveRecord::Migration[5.2]
  def change
    add_index :statuses, [:private_flag, :tweet_id_reversed]
  end
end

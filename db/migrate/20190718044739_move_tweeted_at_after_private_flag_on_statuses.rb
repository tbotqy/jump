class MoveTweetedAtAfterPrivateFlagOnStatuses < ActiveRecord::Migration[5.2]
  def up
    change_column :statuses, :tweeted_at, :integer, null: false, after: :private_flag
  end

  def down
    change_column :statuses, :tweeted_at, :integer, null: false, after: :retweet_count
  end
end

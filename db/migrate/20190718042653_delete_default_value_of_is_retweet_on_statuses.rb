class DeleteDefaultValueOfIsRetweetOnStatuses < ActiveRecord::Migration[5.2]
  def up
    change_column_default(:statuses, :is_retweet, nil)
  end

  def down
    change_column_default(:statuses, :is_retweet, 0)
  end
end

class MakeTweetedOnNotNullOnStatuses < ActiveRecord::Migration[5.2]
  def change
    change_column_null :statuses, :tweeted_on, false
  end
end

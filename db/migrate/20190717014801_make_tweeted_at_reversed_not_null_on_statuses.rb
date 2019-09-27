class MakeTweetedAtReversedNotNullOnStatuses < ActiveRecord::Migration[5.2]
  def change
    change_column_null :statuses, :tweeted_at_reversed, false
  end
end

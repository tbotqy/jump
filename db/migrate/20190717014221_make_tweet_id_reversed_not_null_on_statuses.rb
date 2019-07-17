class MakeTweetIdReversedNotNullOnStatuses < ActiveRecord::Migration[5.2]
  def change
    change_column_null :statuses, :tweet_id_reversed, false
  end
end

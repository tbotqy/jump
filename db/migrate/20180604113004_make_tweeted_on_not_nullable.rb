class MakeTweetedOnNotNullable < ActiveRecord::Migration[5.0]
  def up
    change_column :published_status_tweeted_dates, :tweeted_on, :date, null: false
  end

  def down
  end
end

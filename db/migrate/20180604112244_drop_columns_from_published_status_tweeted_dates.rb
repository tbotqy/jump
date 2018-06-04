class DropColumnsFromPublishedStatusTweetedDates < ActiveRecord::Migration[5.0]
  def up
    remove_column :published_status_tweeted_dates, :posted_date
    remove_column :published_status_tweeted_dates, :posted_unixtime
  end

  def down
  end
end

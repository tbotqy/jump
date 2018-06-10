class DropTablePublishedStatusTweetedDates < ActiveRecord::Migration[5.0]
  def change
    drop_table :published_status_tweeted_dates
  end
end

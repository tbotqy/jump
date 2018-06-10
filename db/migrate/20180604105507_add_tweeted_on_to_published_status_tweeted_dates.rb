class AddTweetedOnToPublishedStatusTweetedDates < ActiveRecord::Migration[5.0]
  def change
    add_column :published_status_tweeted_dates, :tweeted_on, :date, null: true, default: nil
  end
end

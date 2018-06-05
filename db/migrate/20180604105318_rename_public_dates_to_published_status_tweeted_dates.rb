class RenamePublicDatesToPublishedStatusTweetedDates < ActiveRecord::Migration[5.0]
  def change
    rename_table :public_dates, :published_status_tweeted_dates
  end
end

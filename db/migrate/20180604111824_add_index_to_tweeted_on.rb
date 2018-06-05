class AddIndexToTweetedOn < ActiveRecord::Migration[5.0]
  def change
    add_index :published_status_tweeted_dates, :tweeted_on, unique: true
  end
end

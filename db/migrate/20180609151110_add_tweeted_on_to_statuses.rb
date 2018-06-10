class AddTweetedOnToStatuses < ActiveRecord::Migration[5.0]
  def change
    add_column :statuses, :tweeted_on, :date, null: true, default: nil
  end
end

class RemoveTweetedOnFromStatuses < ActiveRecord::Migration[5.2]
  def change
    remove_column :statuses, :tweeted_on, :date, null: true, default: nil, after: :tweeted_at_reversed
  end
end

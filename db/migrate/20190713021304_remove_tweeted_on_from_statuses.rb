class RemoveTweetedOnFromStatuses < ActiveRecord::Migration[5.2]
  def up
    remove_column :statuses, :tweeted_on
  end

  def down
    add_column :statuses, :tweeted_on, :date, null: true, default: nil, after: :tweeted_at_reversed
    add_index  :statuses, :tweeted_on
  end
end

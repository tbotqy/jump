class ChangeTweetedOnToDatetime < ActiveRecord::Migration[5.2]
  def up
    change_column :statuses, :tweeted_on, :datetime
  end

  def down
    change_column :statuses, :tweeted_on, :date
  end
end

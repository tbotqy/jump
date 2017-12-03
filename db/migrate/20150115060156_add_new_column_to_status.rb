class AddNewColumnToStatus < ActiveRecord::Migration
  def change
    add_column :statuses, :twitter_created_at_reversed, :integer
  end
end

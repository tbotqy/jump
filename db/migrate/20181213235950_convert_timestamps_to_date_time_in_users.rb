class ConvertTimestampsToDateTimeInUsers < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :created_at
    remove_column :users, :updated_at
    add_timestamps :users, null: true
  end

  def down
  end
end

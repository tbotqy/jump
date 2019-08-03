class ConvertCreatedAtFromIntToDatetimeOnFollowees < ActiveRecord::Migration[5.2]
  def up
    rename_column :followees, :created_at, :created_at_int

    add_column :followees, :created_at, :datetime, null: true, after: :created_at_int
    connection.execute("UPDATE followees SET created_at = FROM_UNIXTIME(created_at_int)")
    change_column_null :followees, :created_at, false

    remove_column :followees, :created_at_int
  end

  def down
    rename_column :followees, :created_at, :created_at_datetime

    add_column  :followees, :created_at, :integer, null: true, after: :created_at_datetime
    connection.execute("UPDATE followees SET created_at = UNIX_TIMESTAMP(created_at_datetime)")
    change_column_null :followees, :created_at, false

    remove_column :followees, :created_at_datetime
  end
end

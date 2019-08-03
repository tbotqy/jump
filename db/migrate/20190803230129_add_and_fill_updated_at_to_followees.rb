class AddAndFillUpdatedAtToFollowees < ActiveRecord::Migration[5.2]
  def up
    add_column :followees, :updated_at, :datetime, null: true, after: :created_at
    connection.execute("UPDATE followees set updated_at = created_at")
    change_column_null :followees, :updated_at, false
  end

  def down
    remove_column :followees, :updated_at
  end
end

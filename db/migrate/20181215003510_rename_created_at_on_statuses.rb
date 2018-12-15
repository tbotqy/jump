class RenameCreatedAtOnStatuses < ActiveRecord::Migration[5.0]
  def up
   rename_column :statuses, :created_at, :created_at_int
  end

  def down
  end
end

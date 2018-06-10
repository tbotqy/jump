class RenameDeletedFlagToDeletedOnUsersAndStatuses < ActiveRecord::Migration[5.0]
  def change
    rename_column :users,    :deleted_flag, :deleted
    rename_column :statuses, :deleted_flag, :deleted
  end
end

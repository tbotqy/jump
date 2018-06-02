class RenameDeletedFlagToPrivateOnStatuses < ActiveRecord::Migration[5.0]
  def change
    rename_column :statuses, :deleted_flag, :private
  end
end

class RenamePrivateFlagToProtectedFlagOnStatuses < ActiveRecord::Migration[6.0]
  def change
    rename_column :statuses, :private_flag, :protected_flag
  end
end

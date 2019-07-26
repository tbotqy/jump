class RenameProfileUpdateFailLogToUserUpdateFailLog < ActiveRecord::Migration[5.2]
  def change
    rename_table :profile_update_fail_logs, :user_update_fail_logs
  end
end

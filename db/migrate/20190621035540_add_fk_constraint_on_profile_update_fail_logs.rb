# frozen_string_literal: true

class AddFkConstraintOnProfileUpdateFailLogs < ActiveRecord::Migration[5.2]
  def up
    add_foreign_key :profile_update_fail_logs, :users
  end

  def down
    remove_foreign_key :profile_update_fail_logs, :users
    remove_index       :profile_update_fail_logs, :user_id # index for user_id has not been set before this migration
  end
end

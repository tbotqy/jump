# frozen_string_literal: true

class ChangeTypeOfUserIdToBigintOnProfileUpdateFailLogs < ActiveRecord::Migration[5.2]
  def up
    change_column :profile_update_fail_logs, :user_id, :bigint
  end

  def down
    change_column :profile_update_fail_logs, :user_id, :int
  end
end

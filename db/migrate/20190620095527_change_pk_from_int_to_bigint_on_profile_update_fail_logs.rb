# frozen_string_literal: true

class ChangePkFromIntToBigintOnProfileUpdateFailLogs < ActiveRecord::Migration[5.2]
  def up
    change_column :profile_update_fail_logs, :id, :bigint, auto_increment: true
  end

  def down
    change_column :profile_update_fail_logs, :id, :int, auto_increment: true
  end
end

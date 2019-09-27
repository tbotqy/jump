# frozen_string_literal: true

class ChangePkFromIntToBigintOnStatuses < ActiveRecord::Migration[5.2]
  def up
    change_column :statuses, :id, :bigint, auto_increment: true
  end

  def down
    change_column :statuses, :id, :int, auto_increment: true
  end
end

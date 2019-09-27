# frozen_string_literal: true

class ChangePkFromIntToBigintOnFollowees < ActiveRecord::Migration[5.2]
  def up
    change_column :followees, :id, :bigint, auto_increment: true
  end

  def down
    change_column :followees, :id, :int, auto_increment: true
  end
end

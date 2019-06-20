# frozen_string_literal: true

class ChangePkFromIntToBigintOnUsers < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :id, :bigint, auto_increment: true
  end

  def down
    change_column :users, :id, :int, auto_increment: true
  end
end

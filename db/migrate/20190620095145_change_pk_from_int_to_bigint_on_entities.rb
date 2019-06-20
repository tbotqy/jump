# frozen_string_literal: true

class ChangePkFromIntToBigintOnEntities < ActiveRecord::Migration[5.2]
  def up
    change_column :entities, :id, :bigint, auto_increment: true
  end

  def down
    change_column :entities, :id, :int, auto_increment: true
  end
end

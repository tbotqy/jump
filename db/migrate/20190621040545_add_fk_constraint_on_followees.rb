# frozen_string_literal: true

class AddFkConstraintOnFollowees < ActiveRecord::Migration[5.2]
  def up
    add_foreign_key :followees, :users
  end

  def down
    remove_foreign_key :followees, :users
    remove_index       :followees, :user_id # index for user_id has not been set before this migration
  end
end

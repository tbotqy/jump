# frozen_string_literal: true

class RemoveManuallyNamedIndexForUserIdOnFollowees < ActiveRecord::Migration[5.2]
  def up
    remove_index :followees, name: :idx_u_on_friends
  end

  def down
    add_index :followees, :user_id, name: :idx_u_on_friends
  end
end

class AddCombinedUniqueKeyConstraintToUserIdAndTwitterIdOnFollowees < ActiveRecord::Migration[5.2]
  def up
    add_index    :followees, [:user_id, :twitter_id], unique: true
    remove_index :followees, column: :user_id
  end

  def down
    add_index    :followees, :user_id
    remove_index :followees, column: [:user_id, :twitter_id]
  end
end

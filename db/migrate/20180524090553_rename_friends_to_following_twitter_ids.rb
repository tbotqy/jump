class RenameFriendsToFollowingTwitterIds < ActiveRecord::Migration[5.0]
  def change
    rename_table :friends, :following_twitter_ids
  end
end

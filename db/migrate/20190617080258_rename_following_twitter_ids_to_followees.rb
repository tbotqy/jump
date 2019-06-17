# frozen_string_literal: true

class RenameFollowingTwitterIdsToFollowees < ActiveRecord::Migration[5.2]
  def change
    rename_table :following_twitter_ids, :followees
  end
end

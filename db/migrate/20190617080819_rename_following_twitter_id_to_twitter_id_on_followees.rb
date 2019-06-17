# frozen_string_literal: true

class RenameFollowingTwitterIdToTwitterIdOnFollowees < ActiveRecord::Migration[5.2]
  def change
    rename_column :followees, :following_twitter_id, :twitter_id
  end
end

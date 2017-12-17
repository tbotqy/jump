class ChangeColumnToProfileImageUrl < ActiveRecord::Migration
  def up
    change_column :profile_image_urls,:twitter_id,:integer, limit:8
  end

  def down
  end
end

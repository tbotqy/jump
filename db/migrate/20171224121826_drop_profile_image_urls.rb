class DropProfileImageUrls < ActiveRecord::Migration
  def change
    drop_table :profile_image_urls
  end
end

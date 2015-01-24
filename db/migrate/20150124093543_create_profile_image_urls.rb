class CreateProfileImageUrls < ActiveRecord::Migration
  def change
    create_table :profile_image_urls do |t|
      t.integer :twitter_id
      t.string :screen_name
      t.string :url
      t.integer :created_at
      t.integer :updated_at
    end
  end
end

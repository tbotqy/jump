class RenameProfileImageUrlHttpsToAvatarUrlOnUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :profile_image_url_https, :avatar_url
  end
end

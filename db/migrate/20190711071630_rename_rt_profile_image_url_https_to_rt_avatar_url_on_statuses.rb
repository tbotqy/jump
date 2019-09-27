class RenameRtProfileImageUrlHttpsToRtAvatarUrlOnStatuses < ActiveRecord::Migration[5.2]
  def change
    rename_column :statuses, :rt_profile_image_url_https, :rt_avatar_url
  end
end

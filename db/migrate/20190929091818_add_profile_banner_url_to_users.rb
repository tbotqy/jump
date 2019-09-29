class AddProfileBannerUrlToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :profile_banner_url, :string, null: true, after: :avatar_url
  end
end

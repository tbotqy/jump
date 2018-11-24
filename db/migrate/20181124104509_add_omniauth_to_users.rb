class AddOmniauthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :provider, :string, after: :twitter_id
    add_column :users, :uid, :string, after: :id
  end
end

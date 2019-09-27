class RemoveFriendsUpdatedAtFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :friends_updated_at, :integer, null: true, after: :statuses_updated_at
  end
end

class AddUniqueIndexToTwitterIdOnUsers < ActiveRecord::Migration[5.2]
  def up
    remove_index :users, :twitter_id
    add_index :users, :twitter_id, unique: true
  end

  def down
    remove_index :users, :twitter_id
    add_index :users, :twitter_id
  end
end

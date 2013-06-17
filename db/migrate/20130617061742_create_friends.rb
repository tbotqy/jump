class CreateFriends < ActiveRecord::Migration
  def change
    create_table "friends", :force => true do |t|
      t.integer "user_id",              :limit => 8, :null => false
      t.integer "following_twitter_id", :limit => 8, :null => false
      t.integer "created_at",                        :null => false
    end
  end
end

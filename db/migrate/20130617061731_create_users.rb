class CreateUsers < ActiveRecord::Migration
  def change
    create_table "users", :force => true do |t|
      t.integer "twitter_id",              :limit => 8,                    :null => false
      t.string  "name",                                                    :null => false
      t.string  "screen_name",                                             :null => false
      t.string  "profile_image_url_https",                                 :null => false
      t.string  "time_zone"
      t.integer "utc_offset"
      t.integer "twitter_created_at",                                      :null => false
      t.string  "lang",                                                    :null => false
      t.string  "token",                                                   :null => false
      t.string  "token_secret",                                            :null => false
      t.boolean "initialized_flag",                                        :null => false
      t.integer "token_updated_at",                                        :null => false
      t.integer "statuses_updated_at",                                     :null => false
      t.integer "friends_updated_at",                                      :null => false
      t.boolean "closed_only",                          :default => false
      t.boolean "deleted_flag",                         :default => false, :null => false
      t.integer "created_at",                                              :null => false
      t.integer "updated_at",                                              :null => false
    end
  end
end

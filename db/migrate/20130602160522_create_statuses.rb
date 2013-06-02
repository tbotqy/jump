class CreateStatuses < ActiveRecord::Migration
  def change
    create_table "statuses", :force => true do |t|
      t.integer "user_id",                    :limit => 8,                    :null => false
      t.integer "twitter_id",                 :limit => 8,                    :null => false
      t.integer "status_id_str",              :limit => 8,                    :null => false
      t.integer "in_reply_to_status_id_str",  :limit => 8
      t.integer "in_reply_to_user_id_str",    :limit => 8
      t.string  "in_reply_to_screen_name"
      t.string  "place_full_name"
      t.integer "retweet_count"
      t.integer "created_at",                                                 :null => false
      t.string  "source",                                                     :null => false
      t.string  "text",                                                       :null => false
      t.boolean "is_retweet",                              :default => false, :null => false
      t.string  "rt_name"
      t.string  "rt_screen_name"
      t.string  "rt_profile_image_url_https"
      t.string  "rt_text"
      t.string  "rt_source"
      t.integer "rt_created_at"
      t.boolean "possibly_sensitive",                                         :null => false
      t.boolean "pre_saved",                                                  :null => false
      t.integer "created",                                                    :null => false
    end
    
    add_index "statuses", ["created_at"], :name => "created_at"
  end
end

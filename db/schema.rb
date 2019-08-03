# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_03_230129) do

  create_table "entities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "status_id", null: false
    t.string "url"
    t.string "display_url"
    t.string "hashtag"
    t.string "mention_to_screen_name"
    t.bigint "mention_to_user_id_str"
    t.integer "indice_f", null: false
    t.integer "indice_l", null: false
    t.string "entity_type", null: false
    t.integer "created_at", null: false
    t.index ["status_id"], name: "fk_rails_994021b93c"
  end

  create_table "followees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "twitter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "twitter_id"], name: "index_followees_on_user_id_and_twitter_id", unique: true
  end

  create_table "hashtags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "status_id", null: false
    t.string "text", null: false
    t.integer "index_f", null: false
    t.integer "index_l", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_hashtags_on_status_id"
  end

  create_table "media", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "status_id", null: false
    t.string "url", null: false
    t.string "direct_url"
    t.string "display_url", null: false
    t.integer "index_f", null: false
    t.integer "index_l", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_media_on_status_id"
  end

  create_table "statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tweet_id", null: false
    t.bigint "in_reply_to_tweet_id"
    t.bigint "in_reply_to_user_id_str"
    t.string "in_reply_to_screen_name"
    t.string "place_full_name"
    t.integer "retweet_count"
    t.string "source", null: false
    t.string "text", limit: 280, null: false
    t.boolean "is_retweet", null: false
    t.string "rt_name"
    t.string "rt_screen_name"
    t.string "rt_avatar_url"
    t.string "rt_text"
    t.string "rt_source"
    t.integer "rt_created_at"
    t.boolean "possibly_sensitive", null: false
    t.boolean "private_flag", null: false
    t.integer "tweeted_at", null: false
    t.bigint "tweet_id_reversed", null: false
    t.integer "tweeted_at_reversed", null: false
    t.date "tweeted_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tweet_id"], name: "index_statuses_on_tweet_id", unique: true
    t.index ["tweeted_on", "private_flag"], name: "index_statuses_on_tweeted_on_and_private_flag"
    t.index ["tweeted_on"], name: "index_statuses_on_tweeted_on"
    t.index ["user_id"], name: "index_statuses_on_user_id"
  end

  create_table "tweet_import_locks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tweet_import_locks_on_user_id", unique: true
  end

  create_table "tweet_import_progresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "finished", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tweet_import_progresses_on_user_id", unique: true
  end

  create_table "urls", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "status_id", null: false
    t.string "url", null: false
    t.string "display_url", null: false
    t.integer "index_f", null: false
    t.integer "index_l", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_urls_on_status_id"
  end

  create_table "user_update_fail_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "error_message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "fk_rails_daeb5deee9"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "uid", null: false
    t.bigint "twitter_id", null: false
    t.string "provider", null: false
    t.string "name", null: false
    t.string "screen_name", null: false
    t.boolean "protected_flag", default: false, null: false
    t.string "avatar_url", null: false
    t.integer "twitter_created_at", null: false
    t.string "access_token", null: false
    t.string "access_token_secret", null: false
    t.integer "token_updated_at"
    t.integer "statuses_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twitter_id"], name: "index_users_on_twitter_id", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "entities", "statuses"
  add_foreign_key "followees", "users"
  add_foreign_key "hashtags", "statuses"
  add_foreign_key "media", "statuses"
  add_foreign_key "statuses", "users"
  add_foreign_key "tweet_import_locks", "users"
  add_foreign_key "tweet_import_progresses", "users"
  add_foreign_key "urls", "statuses"
  add_foreign_key "user_update_fail_logs", "users"
end

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

ActiveRecord::Schema.define(version: 2019_07_18_040233) do

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
    t.integer "created_at", null: false
    t.index ["user_id"], name: "fk_rails_18581d83f3"
  end

  create_table "hashtags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "status_id", null: false
    t.string "hashtag", null: false
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

  create_table "profile_update_fail_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "error_message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "fk_rails_daeb5deee9"
  end

  create_table "statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tweet_id", null: false
    t.bigint "in_reply_to_tweet_id"
    t.bigint "in_reply_to_user_id_str"
    t.string "in_reply_to_screen_name"
    t.string "place_full_name"
    t.integer "retweet_count"
    t.integer "tweeted_at", null: false
    t.string "source", null: false
    t.string "text", limit: 280, null: false
    t.boolean "is_retweet", default: false, null: false
    t.string "rt_name"
    t.string "rt_screen_name"
    t.string "rt_avatar_url"
    t.string "rt_text"
    t.string "rt_source"
    t.integer "rt_created_at"
    t.boolean "possibly_sensitive", null: false
    t.boolean "private_flag", null: false
    t.bigint "tweet_id_reversed", null: false
    t.integer "tweeted_at_reversed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tweet_id"], name: "index_statuses_on_tweet_id", unique: true
    t.index ["user_id"], name: "index_statuses_on_user_id"
  end

  create_table "tweet_import_job_progresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "job_id", limit: 36, null: false
    t.bigint "user_id", null: false
    t.integer "count", default: 0, null: false
    t.integer "percentage_denominator", null: false
    t.boolean "finished", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "fk_rails_e62285fa61"
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
    t.boolean "closed_only", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twitter_id"], name: "index_users_on_twitter_id"
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "entities", "statuses"
  add_foreign_key "followees", "users"
  add_foreign_key "hashtags", "statuses"
  add_foreign_key "media", "statuses"
  add_foreign_key "profile_update_fail_logs", "users"
  add_foreign_key "statuses", "users"
  add_foreign_key "tweet_import_job_progresses", "users"
  add_foreign_key "urls", "statuses"
end

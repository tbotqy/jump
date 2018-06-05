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

ActiveRecord::Schema.define(version: 20180605172419) do

  create_table "entities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.bigint  "status_id",              null: false
    t.string  "url"
    t.string  "display_url"
    t.string  "hashtag"
    t.string  "mention_to_screen_name"
    t.bigint  "mention_to_user_id_str"
    t.integer "indice_f",               null: false
    t.integer "indice_l",               null: false
    t.string  "entity_type",            null: false
    t.integer "created_at",             null: false
    t.index ["status_id"], name: "status_id", using: :btree
  end

  create_table "following_twitter_ids", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.bigint  "user_id",              null: false
    t.bigint  "following_twitter_id", null: false
    t.integer "created_at",           null: false
    t.index ["user_id"], name: "idx_u_on_friends", using: :btree
  end

  create_table "published_status_tweeted_dates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.date "tweeted_on", null: false
    t.index ["tweeted_on"], name: "index_published_status_tweeted_dates_on_tweeted_on", unique: true, using: :btree
  end

  create_table "statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.bigint  "user_id",                                               null: false
    t.bigint  "status_id_str",                                         null: false
    t.bigint  "in_reply_to_status_id_str"
    t.bigint  "in_reply_to_user_id_str"
    t.string  "in_reply_to_screen_name"
    t.string  "place_full_name"
    t.integer "retweet_count"
    t.integer "twitter_created_at",                                    null: false
    t.string  "source",                                                null: false
    t.string  "text",                                                  null: false
    t.boolean "is_retweet",                            default: false, null: false
    t.string  "rt_name"
    t.string  "rt_screen_name"
    t.string  "rt_profile_image_url_https"
    t.string  "rt_text"
    t.string  "rt_source"
    t.integer "rt_created_at"
    t.boolean "possibly_sensitive",                                    null: false
    t.boolean "private",                               default: false, null: false
    t.integer "created_at",                                            null: false
    t.integer "deleted",                     limit: 1, default: 0,     null: false
    t.bigint  "status_id_str_reversed"
    t.integer "twitter_created_at_reversed"
    t.index ["status_id_str_reversed"], name: "idx_sisr_on_statuses", using: :btree
    t.index ["twitter_created_at_reversed", "status_id_str_reversed"], name: "idx_tcar_sisr_on_statuses", using: :btree
    t.index ["user_id", "twitter_created_at_reversed", "status_id_str_reversed"], name: "idx_u_tcar_sisr_on_statuses", using: :btree
    t.index ["user_id", "twitter_created_at_reversed"], name: "idx_u_tcar_on_statuses", using: :btree
    t.index ["user_id"], name: "idx_u_on_statuses", using: :btree
  end

  create_table "tweet_import_job_progresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "job_id",     limit: 36,                 null: false
    t.integer  "user_id",                               null: false
    t.integer  "count",                 default: 0,     null: false
    t.boolean  "finished",              default: false, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.bigint  "twitter_id",                              null: false
    t.string  "name",                                    null: false
    t.string  "screen_name",                             null: false
    t.boolean "protected",               default: false, null: false
    t.string  "profile_image_url_https",                 null: false
    t.string  "time_zone"
    t.integer "utc_offset"
    t.integer "twitter_created_at",                      null: false
    t.string  "lang",                                    null: false
    t.string  "token",                                   null: false
    t.string  "token_secret",                            null: false
    t.boolean "finished_initial_import", default: false, null: false
    t.integer "token_updated_at"
    t.integer "statuses_updated_at"
    t.integer "friends_updated_at"
    t.boolean "closed_only",             default: false
    t.boolean "deleted",                 default: false, null: false
    t.integer "created_at",                              null: false
    t.integer "updated_at",                              null: false
    t.index ["twitter_id"], name: "idx_ti_on_users", using: :btree
  end

end

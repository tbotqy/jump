# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20171224122928) do

  create_table "data_summaries", force: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string  "type"
    t.integer "value",      limit: 8
    t.integer "updated_at"
  end

  create_table "entities", force: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer "status_id",              limit: 8, null: false
    t.string  "url"
    t.string  "display_url"
    t.string  "hashtag"
    t.string  "mention_to_screen_name"
    t.integer "mention_to_user_id_str", limit: 8
    t.integer "indice_f",                         null: false
    t.integer "indice_l",                         null: false
    t.string  "entity_type",                      null: false
    t.integer "created_at",                       null: false
  end

  add_index "entities", ["status_id"], name: "status_id", using: :btree

  create_table "friends", force: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer "user_id",              limit: 8, null: false
    t.integer "following_twitter_id", limit: 8, null: false
    t.integer "created_at",                     null: false
  end

  add_index "friends", ["user_id"], name: "idx_u_on_friends", using: :btree

  create_table "public_dates", force: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string  "posted_date",     limit: 10, null: false
    t.integer "posted_unixtime",            null: false
  end

  add_index "public_dates", ["posted_date"], name: "posted_date", unique: true, using: :btree
  add_index "public_dates", ["posted_unixtime"], name: "posted_unixtime", using: :btree

  create_table "statuses", force: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer "user_id",                     limit: 8,                 null: false
    t.integer "twitter_id",                  limit: 8,                 null: false
    t.integer "status_id_str",               limit: 8,                 null: false
    t.integer "in_reply_to_status_id_str",   limit: 8
    t.integer "in_reply_to_user_id_str",     limit: 8
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
    t.boolean "pre_saved",                                             null: false
    t.integer "created_at",                                            null: false
    t.integer "deleted_flag",                limit: 1, default: 0,     null: false
    t.integer "status_id_str_reversed",      limit: 8
    t.integer "twitter_created_at_reversed"
  end

  add_index "statuses", ["status_id_str_reversed"], name: "idx_sisr_on_statuses", using: :btree
  add_index "statuses", ["twitter_created_at_reversed", "status_id_str_reversed"], name: "idx_tcar_sisr_on_statuses", using: :btree
  add_index "statuses", ["user_id", "twitter_created_at_reversed", "status_id_str_reversed"], name: "idx_u_tcar_sisr_on_statuses", using: :btree
  add_index "statuses", ["user_id", "twitter_created_at_reversed"], name: "idx_u_tcar_on_statuses", using: :btree
  add_index "statuses", ["user_id"], name: "idx_u_on_statuses", using: :btree

  create_table "users", force: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.integer "twitter_id",              limit: 8,                 null: false
    t.string  "name",                                              null: false
    t.string  "screen_name",                                       null: false
    t.string  "profile_image_url_https",                           null: false
    t.string  "time_zone"
    t.integer "utc_offset"
    t.integer "twitter_created_at",                                null: false
    t.string  "lang",                                              null: false
    t.string  "token",                                             null: false
    t.string  "token_secret",                                      null: false
    t.boolean "initialized_flag",                  default: false, null: false
    t.integer "token_updated_at"
    t.integer "statuses_updated_at"
    t.integer "friends_updated_at"
    t.boolean "closed_only",                       default: false
    t.boolean "deleted_flag",                      default: false, null: false
    t.integer "created_at",                                        null: false
    t.integer "updated_at",                                        null: false
  end

  add_index "users", ["twitter_id"], name: "idx_ti_on_users", using: :btree

end

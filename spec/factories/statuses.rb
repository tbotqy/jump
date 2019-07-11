# frozen_string_literal: true

FactoryBot.define do
  factory :status do
    user
    status_id_str { 111111111111111111 }
    in_reply_to_status_id_str { nil }
    in_reply_to_user_id_str { nil }
    in_reply_to_screen_name { nil }
    place_full_name { nil }
    retweet_count { 0 }
    twitter_created_at { 1343637257 }
    source { "web" }
    text { "Hello, This is a tweet in factory." }
    is_retweet { 0 }
    rt_name { nil }
    rt_screen_name { nil }
    rt_avatar_url { nil }
    rt_text { nil }
    rt_source { nil }
    rt_created_at { nil }
    possibly_sensitive { 0 }
    private_flag { 0 }
    status_id_str_reversed { -1 * status_id_str }
    twitter_created_at_reversed { -1 * twitter_created_at }
    tweeted_on { Time.at(twitter_created_at).in_time_zone.to_date }
  end
end

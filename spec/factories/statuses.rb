# frozen_string_literal: true

FactoryBot.define do
  factory :status do
    user
    tweet_id { tweeted_at }
    in_reply_to_tweet_id { nil }
    in_reply_to_user_id_str { nil }
    in_reply_to_screen_name { nil }
    place_full_name { nil }
    retweet_count { 0 }
    sequence(:tweeted_at)
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
    tweet_id_reversed { -1 * tweet_id }
    tweeted_at_reversed { -1 * tweeted_at }
  end
end

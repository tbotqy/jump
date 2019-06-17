# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    uid { "123456789" }
    twitter_id { 123456789 }
    provider { "twitter" }
    name { "test_name" }
    screen_name { "test_screen_name" }
    protected { false }
    profile_image_url_https { "https//pbs.twimg.com/profile_images/0000000000/hoge_normal.jpeg" }
    twitter_created_at { 1342689117 }
    token { "test_token" }
    token_secret { "test_token_secret" }
    token_updated_at { 1482676460 }
    statuses_updated_at { 1482676461 }
    friends_updated_at { 1482774672 }
    closed_only { false }

    trait(:with_friend) do
      after(:create) do |u|
        FactoryBot.create(:following_twitter_id, user_id: u.id)
      end
    end

    trait(:with_no_friend) do
    end

    trait(:with_status) do
      after(:create) do |u|
        FactoryBot.create(:status, user_id: u.id)
      end
    end

    trait(:with_no_status) do
    end
  end
end

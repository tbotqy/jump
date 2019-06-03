# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    uid 123456789
    twitter_id 123456789
    provider "twitter"
    name "test_name"
    screen_name "test_screen_name"
    protected 0
    profile_image_url_https "https//pbs.twimg.com/profile_images/0000000000/hoge_normal.jpeg"
    twitter_created_at 1342689117
    token "hoge"
    token_secret "fuga"
    token_updated_at 1
    statuses_updated_at 1482676461
    friends_updated_at 1482774672
    closed_only 0
    deleted 0
    created_at 1345305649
    updated_at 1482774672

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

# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:uid) { |n| "123456789#{n}" }
    sequence(:twitter_id) { |n| "123456789#{n}".to_i }
    provider { "twitter" }
    name { "test_name" }
    screen_name { "test_screen_name" }
    protected_flag { false }
    profile_image_url_https { "https//pbs.twimg.com/profile_images/0000000000/hoge_normal.jpeg" }
    twitter_created_at { 1342689117 }
    token { "test_token" }
    token_secret { "test_token_secret" }
    token_updated_at { 1482676460 }
    statuses_updated_at { 1482676461 }
    closed_only { false }

    trait(:with_statuses_and_followees) do
      transient do
        status_count   { 5 }
        followee_count { 10 }
      end

      after(:create) do |user, evaluator|
        # create followees of the user
        followees = create_list(:user, evaluator.followee_count)
        ## register created users as user's followees
        followees.pluck(:twitter_id).each { |twitter_id| create(:followee, user: user, twitter_id: twitter_id) }

        # create user's statuses
        create_list(:status, evaluator.status_count, user: user)
      end
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

FactoryBot.define do
  factory :user do

    twitter_id 123456789
    name "test_name"
    screen_name "test_screen_name"
    profile_image_url_https "https//pbs.twimg.com/profile_images/0000000000/hoge_normal.jpeg"
    time_zone "Tokyo"
    utc_offset 32400
    twitter_created_at 1342689117
    lang "ja"
    token "hoge"
    token_secret "fuga"
    token_updated_at 1
    statuses_updated_at 1482676461
    friends_updated_at 1482774672
    closed_only 0
    deleted_flag 0
    created_at 1345305649
    updated_at 1482774672

    trait(:with_friend) do
      after(:create) do |u|
        FactoryBot.create(:friend, user_id: u.id)
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

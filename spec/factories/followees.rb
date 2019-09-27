# frozen_string_literal: true

FactoryBot.define do
  factory :followee do
    user
    sequence(:twitter_id) { |n| "123456789#{n}".to_i }
  end
end

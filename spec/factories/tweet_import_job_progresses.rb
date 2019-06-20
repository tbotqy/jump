# frozen_string_literal: true

FactoryBot.define do
  factory :tweet_import_job_progress do
    sequence(:job_id) { |n| "abcdefg#{n}" }
    user
    count { 3200 }
    finished { false }
  end
end

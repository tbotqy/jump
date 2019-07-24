# frozen_string_literal: true

FactoryBot.define do
  factory :tweet_import_progress do
    user
    count { 0 }
    finished { false }
  end
end

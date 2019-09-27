# frozen_string_literal: true

FactoryBot.define do
  factory :tweet_import_progress do
    user
    finished { false }
  end
end

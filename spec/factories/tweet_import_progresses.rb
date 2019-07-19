# frozen_string_literal: true

FactoryBot.define do
  factory :tweet_import_progress do
    user
    count { 3200 }
    percentage_denominator { 3200 }
  end
end

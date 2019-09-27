# frozen_string_literal: true

FactoryBot.define do
  factory :url do
    status
    url { "https://t.co/abcd" }
    display_url { "twitter.com/foo" }
    index_f { 1 }
    index_l { index_f + url.size }
  end
end

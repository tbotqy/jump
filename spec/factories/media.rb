# frozen_string_literal: true

FactoryBot.define do
  factory :medium do
    status
    url { "http://t.co/rJC5Pxsug" }
    direct_url { "http://pbs.twimg.com/media/DOhM30VVwAEpIHq.jpg" }
    display_url { "pic.twitter.com/rJC5Pxsu" }
    index_f { 1 }
    index_l { index_f + url.size }
  end
end

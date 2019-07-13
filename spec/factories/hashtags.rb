# frozen_string_literal: true

FactoryBot.define do
  factory :hashtag do
    status
    hashtag { "test" }
    index_f { 1 }
    index_l { index_f + hashtag.size + 1 } # 1 == "#".size
  end
end

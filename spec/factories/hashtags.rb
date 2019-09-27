# frozen_string_literal: true

FactoryBot.define do
  factory :hashtag do
    status
    text { "test" }
    index_f { 1 }
    index_l { index_f + text.size + 1 } # 1 == "#".size
  end
end

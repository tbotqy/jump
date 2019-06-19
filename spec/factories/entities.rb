# frozen_string_literal: true

FactoryBot.define do
  factory :entity do
    status
    url { "https://t.co/foobarbaz" }
    display_url { "foo.com" }
    hashtag { "foobarbaz" }
    mention_to_screen_name { "foo_bar_bax" }
    mention_to_user_id_str { "12345" }
    indice_f { 1 }
    indice_l { 3 }
    entity_type { "user_mentions" }
  end
end

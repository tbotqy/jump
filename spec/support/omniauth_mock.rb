# frozen_string_literal: true

module OmniauthMock
  # mock of an auth hash given by omniauth-twitter
  # NOTE: only required attrs are written
  def auth_hash_mock
    OmniAuth::AuthHash.new(
      provider: "twitter",
      uid:      "123456789012345678",
      credentials: {
        token: "abcdef1234",
        secret: "1234abcdef"
      },
      extra: {
        raw_info: {
          name: "name",
          screen_name: "screen_name",
          profile_image_url_https: "https://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
          created_at: "Thu Jul 4 00:00:00 +0000 2013",
          protected: false
        }
      }
    )
  end
end

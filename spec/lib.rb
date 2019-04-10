# frozen_string_literal: true

module Lib
  # create the Struct which behaves like OmniAuth::AuthHash
  def auth_hash
    auth_hash_struct   = Struct.new(:uid, :provider, :credentials, :extra)
    credentials_struct = Struct.new(:token, :secret)
    extra_struct       = Struct.new(:raw_info)
    raw_info_struct    = Struct.new(:id, :name, :screen_name, :profile_image_url_https, :time_zone, :utc_offset, :created_at, :lang, :protected?)

    raw_info = raw_info_struct.new(
      123456789,
      "test_name",
      "test_screen_name",
      "https://pbs.twimg.com/profile_images/000000000000000000/hoge_normal.jpeg",
      "Tokyo",
      32400,
      "Sat Sep 25 03:22:28 +0000 2010",
      "ja",
      false
    )

    auth_hash_struct.new(raw_info.id, "twitter", credentials_struct.new("test_token", "test_secret"), extra_struct.new(raw_info))
  end
end

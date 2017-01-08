module Lib

  # create an OmniAuth::AuthHash
  def auth_hash
    auth_hash_struct   = Struct.new(:credentials, :extra)
    credentials_struct = Struct.new(:token, :secret)
    extra_struct       = Struct.new(:raw_info)
    raw_info_struct    = Struct.new(:id, :name, :screen_name, :profile_image_url_https, :time_zone, :utc_offset, :created_at, :lang)

    raw_info = raw_info_struct.new(
      123456789,
      "test_name",
      "test_screen_name",
      "https://pbs.twimg.com/profile_images/000000000000000000/hoge_normal.jpeg",
      "Tokyo",
      32400,
      "Sat Sep 25 03:22:28 +0000 2010",
      "ja"
    )

    auth_hash_struct.new(credentials_struct.new("test_token", "test_secret"), extra_struct.new(raw_info))
  end
end

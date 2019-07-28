# frozen_string_literal: true

module TwitterUserMock
  def twitter_user_mock(attrs = {})
    user_attrs = default_twitter_user_attrs.merge(attrs)
    user_attrs[:profile_image_url_https] = Addressable::URI.parse(user_attrs[:profile_image_url_https].to_s)
    instance_double("Twitter::User", user_attrs)
  end

  private
    def default_twitter_user_attrs
      {
        name:                    "name",
        screen_name:             "screen_name",
        protected?:              false,
        profile_image_url_https: Addressable::URI.parse("https://example.com/foo.jpg")
      }
    end
end

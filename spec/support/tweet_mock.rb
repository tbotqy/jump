# frozen_string_literal: true

module TweetMock
  def tweet_mock(twitter_account_id:, **attrs)
    # set user_mock to :user attribute
    tweet_attrs = default_tweet_attrs.merge(user: user_mock(id: twitter_account_id))
    # overwrite attributes with given ones if given
    tweet_attrs = tweet_attrs.merge(attrs) if attrs.present?
    instance_double("Twitter::Tweet", tweet_attrs)
  end

  def incomplete_hashtag_mock
    hashtag_mock(text: "")
  end

  def incomplete_url_mock
    url_mock(url: "")
  end

  def incomplete_media_mock
    medium_mock(url: "")
  end

  private
    def default_tweet_attrs
      {
        id:                      100,
        in_reply_to_tweet_id:    1,
        in_reply_to_user_id:     2,
        in_reply_to_screen_name: "in_reply_to_screen_name",
        retweet_count:           10,
        created_at:              Time.now.utc,
        source:                  "rspec",
        text:                    "default text",
        possibly_sensitive?:     false,
        retweet?:                true,
        place:                   place_mock,
        user:                    nil,
        retweeted_tweet:         retweeted_tweet_mock,
        hashtags:                hashtag_mocks,
        urls:                    url_mocks,
        media:                   medium_mocks
      }
    end

    def hashtag_mocks
      (1..2).to_a.map do |i|
        hashtag_mock(text: "hashtag #{i}", indices: [0, 10])
      end
    end

    def url_mocks
      (1..2).to_a.map do |i|
        url_mock(url: "url #{i}", display_url: "display url #{i}", indices: [0, 4])
      end
    end

    def medium_mocks
      (1..2).to_a.map do |i|
        medium_mock(url: "url #{i}", media_url: "media url #{i}", display_url: "display url #{i}", indices: [0, 4])
      end
    end

    def hashtag_mock(text: "hashtag", indices: [0, 7])
      instance_double("Twitter::Entity::Hashtag", text: text, indices: indices)
    end

    def url_mock(url: "url", display_url: "display url", indices: [0, 4])
      instance_double("Twitter::Entity::URI", url: url, display_url: display_url, indices: indices)
    end

    def medium_mock(url: "url", media_url: "media url", display_url: "display url", indices: [0, 4])
      instance_double("Twitter::Media::Photo", url: url, media_url: media_url, display_url: display_url, indices: indices)
    end

    def place_mock
      instance_double("Twitter::Place", full_name: "place full name")
    end

    def user_mock(id:)
      instance_double("Twitter::User", id: id, protected?: false)
    end

    def retweeted_tweet_mock
      instance_double("Twitter::Tweet",
        text: "rt text",
        source: "rt source",
        created_at: Time.now.utc,
        user: retweeted_tweet_user_mock
      )
    end

    def retweeted_tweet_user_mock
      instance_double("Twitter::User",
        name: "rt name",
        screen_name: "rs_screen_name",
        profile_image_url_https: "https://profile_image/url.jpg"
      )
    end
end
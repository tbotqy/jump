# frozen_string_literal: true

class RegisterTweetService
  private_class_method :new

  class << self
    def call!(tweet:)
      new(tweet).send(:call!)
    end
  end

  private
    def initialize(tweet)
      @tweet = tweet
    end

    def call!
      status = user.statuses.build(status_params)
      hashtag_params.each { |hashtag_param| status.hashtags.build(hashtag_param) }
      url_params.each     { |url_param|     status.urls.build(url_param) }
      medium_params.each  { |medium_param|  status.media.build(medium_param) }
      status.save!
    end

    concerning :ParameterGeneration do
      attr_reader :tweet
      delegate :retweeted_tweet, to: :tweet

      def status_params
        tweet_id   = tweet.id
        tweeted_at = tweet.created_at
        tweeted_at_int = tweeted_at.to_i
        ret = {
          tweet_id:                tweet_id,
          tweet_id_reversed:       -1 * tweet_id,
          in_reply_to_tweet_id:    tweet.in_reply_to_tweet_id,
          in_reply_to_twitter_id:  tweet.in_reply_to_user_id,
          in_reply_to_screen_name: tweet.in_reply_to_screen_name,
          place_full_name:         tweet.place.full_name,
          retweet_count:           tweet.retweet_count,
          tweeted_at:              tweeted_at_int,
          tweeted_at_reversed:     -1 * tweeted_at_int,
          tweeted_on:              tweeted_at.in_time_zone.beginning_of_day,
          source:                  tweet.source,
          text:                    tweet.attrs[:full_text],
          possibly_sensitive:      tweet.possibly_sensitive?,
          protected_flag:          tweet.user.protected?,
          is_retweet:              tweet.retweet?
        }
        if tweet.retweet?
          ret.merge!(
            rt_name:        retweeted_tweet.user.name,
            rt_screen_name: retweeted_tweet.user.screen_name,
            rt_avatar_url:  retweeted_tweet.user.profile_image_url_https.to_s,
            rt_text:        retweeted_tweet.attrs[:full_text],
            rt_source:      retweeted_tweet.source,
            rt_created_at:  retweeted_tweet.created_at.to_i
          )
        end
        ret
      end

      def hashtag_params
        tweet_hashtags = (tweet.retweet? ? retweeted_tweet : tweet).hashtags
        tweet_hashtags.map do |tweet_hashtag|
          {
            text:    tweet_hashtag.text,
            index_f: tweet_hashtag.indices.first,
            index_l: tweet_hashtag.indices.last
          }
        end
      end

      def url_params
        tweet_urls = (tweet.retweet? ? retweeted_tweet : tweet).urls
        tweet_urls.map do |tweet_url|
          {
            url:         tweet_url.url,
            display_url: tweet_url.display_url,
            index_f:     tweet_url.indices.first,
            index_l:     tweet_url.indices.last
          }
        end
      end

      def medium_params
        tweet_media = (tweet.retweet? ? retweeted_tweet : tweet).media
        tweet_media.map do |tweet_medium|
          {
            url:         tweet_medium.url,
            direct_url:  tweet_medium.media_url_https,
            display_url: tweet_medium.display_url,
            index_f:     tweet_medium.indices.first,
            index_l:     tweet_medium.indices.last
          }
        end
      end
    end

    def user
      @user ||= User.find_by!(twitter_id: tweet.user.id)
    end
end

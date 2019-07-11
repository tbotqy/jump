# frozen_string_literal: true

class Status < ApplicationRecord
  belongs_to :user
  has_many :entities, dependent: :delete_all
  scope :not_private, -> { where(private_flag: false) }
  scope :order_for_timeline, -> { order(twitter_created_at_reversed: :asc, tweet_id_reversed: :asc) }
  scope :tweeted_at_or_before, -> (time) do
    boundary = time.to_i
    where("twitter_created_at_reversed >= ?", -1 * boundary)
  end

  after_save :update_user_timestamp

  class << self
    def newest_in_tweeted_time
      order(twitter_created_at_reversed: :asc).first
    end

    def save_tweets!(user_id, tweets)
      Array.wrap(tweets).each do |tweet|
        status          = new_by_tweet(tweet)
        status.user_id  = user_id
        status.entities = Entity.bulk_new_by_tweet(tweet)
        status.save!
      end
    end

    private
      def new_by_tweet(tweet)
        ret = new(
          tweet_id: tweet.attrs[:id_str],
          tweet_id_reversed: -1 * tweet.attrs[:id_str].to_i,
          in_reply_to_tweet_id: tweet.attrs[:in_reply_to_status_id_str],
          in_reply_to_user_id_str: tweet.attrs[:in_reply_to_user_id_str],
          in_reply_to_screen_name: tweet.in_reply_to_screen_name,
          place_full_name: tweet.place.try!(:full_name),
          retweet_count: tweet.retweet_count,
          tweeted_on: Time.at(tweet.created_at.to_i).in_time_zone.to_date,
          twitter_created_at: Time.parse(tweet.created_at.to_s).to_i,
          twitter_created_at_reversed: -1 * Time.parse(tweet.created_at.to_s).to_i,
          source: tweet.source,
          text: tweet.text,
          possibly_sensitive: tweet.possibly_sensitive? || false,
          private_flag: tweet.user.protected?
        )
        ret.assign_retweeted_status(tweet.retweeted_status) if tweet.retweet?
        ret
      end
  end

  def as_json(_options = {})
    {
      tweet_id:   tweet_id,
      text:       text,
      tweeted_at: Time.at(twitter_created_at).in_time_zone.iso8601,
      is_retweet: is_retweet,
      entities:   entities.as_json,
      user:       user.as_json
    }
  end

  def update_user_timestamp
    user.update_attribute(:statuses_updated_at, Time.now.to_i)
  end

  def assign_retweeted_status(retweeted_status)
    self.is_retweet = true
    self.rt_name = retweeted_status.user.name
    self.rt_screen_name = retweeted_status.user.screen_name
    self.rt_avatar_url = retweeted_status.user.profile_image_url_https.to_s
    self.rt_text = retweeted_status.text
    self.rt_source = retweeted_status.source
    self.rt_created_at = retweeted_status.created_at.to_i
  end
end

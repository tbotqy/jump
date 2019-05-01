# frozen_string_literal: true

class Status < ApplicationRecord
  belongs_to :user
  has_many :entities, dependent: :delete_all
  scope :not_deleted, -> { where(deleted: false) }
  scope :not_private, -> { where(private: false) }
  scope :tweeted_by, ->(user_ids) { where(user_id: user_ids) }
  scope :tweeted_by_friend_of, ->(user_id) do
    friend_user_ids = User.find(user_id).friend_user_ids
    tweeted_by(friend_user_ids)
  end

  scope :order_for_timeline, -> { order("twitter_created_at_reversed ASC", "status_id_str_reversed ASC") }
  scope :force_index, ->(index_name) { from("#{table_name} FORCE INDEX(#{index_name})") }
  after_save :update_user_timestamp

  class << self
    def ordered_tweeted_unixtimes_by_user_id(user_id)
      tweeted_by(user_id).order(twitter_created_at_reversed: :asc).pluck(:twitter_created_at)
    end

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

    def get_latest_status(limit = 10)
      includes(:user, :entities).limit(limit).order_for_timeline
    end

    def get_status_in_date(date = "YYYY(/MM(/DD))", limit = 10)
      # search the statuses tweeted in given date

      # calculate the beginning and ending time of given date in unixtime
      date = calc_from_and_to_of(date)
      includes(:user, :entities).where(twitter_created_at_reversed: -1 * date[:to]..-1 * date[:from]).limit(limit).order_for_timeline
    end

    def get_older_status_by_tweet_id(threshold_tweet_id, limit = 10)
      # search the statuses whose status_id_str is smaller than given threshold_tweet_id
      # used to proccess read more button's request
      # use status_id_str_reversed in order to search by index
      threshold_tweet_id_revered = -1 * threshold_tweet_id.to_i
      includes(:user).where("statuses.status_id_str_reversed > ?", threshold_tweet_id_revered).limit(limit).order(:status_id_str_reversed)
    end

    private

      def new_by_tweet(tweet)
        ret = new(
          status_id_str: tweet.attrs[:id_str],
          status_id_str_reversed: -1 * tweet.attrs[:id_str].to_i,
          in_reply_to_status_id_str: tweet.attrs[:in_reply_to_status_id_str],
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
          private: tweet.user.protected?,
          deleted: false
        )
        ret.assign_retweeted_status(tweet.retweeted_status) if tweet.retweet?
        ret
      end

      def calc_from_and_to_of(date)
        # calculate the start/end date of given date in unixtime

        # detect the type of given date
        parts = date.to_s.split(/-/)

        year = parts[0].to_i
        month = parts[1].to_i
        day = parts[2].to_i

        ret = {}
        offset_rational = Rational(Time.zone.utc_offset / 3600, 24)
        case parts.size
        when 1 # only year is specified
          ret[:from] = DateTime.new(year).new_offset(offset_rational).beginning_of_year.to_i
          ret[:to] = DateTime.new(year).new_offset(offset_rational).end_of_year.to_i
        when 2 # year and month is specified
          ret[:from] = DateTime.new(year, month).new_offset(offset_rational).beginning_of_month.to_i
          ret[:to] = DateTime.new(year, month).new_offset(offset_rational).end_of_month.to_i
        when 3 # year and month and day is specified
          ret[:from] = DateTime.new(year, month, day).new_offset(offset_rational).beginning_of_day.to_i
          ret[:to] = DateTime.new(year, month, day).new_offset(offset_rational).end_of_day.to_i
        end

        ret
      end
  end

  def update_user_timestamp
    user.update_attribute(:statuses_updated_at, Time.now.to_i)
  end

  def assign_retweeted_status(retweeted_status)
    self.is_retweet = true
    self.rt_name = retweeted_status.user.name
    self.rt_screen_name = retweeted_status.user.screen_name
    self.rt_profile_image_url_https = retweeted_status.user.profile_image_url_https.to_s
    self.rt_text = retweeted_status.text
    self.rt_source = retweeted_status.source
    self.rt_created_at = retweeted_status.created_at.to_i
  end
end

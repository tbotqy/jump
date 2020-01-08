# frozen_string_literal: true

class Status < ApplicationRecord
  belongs_to :user
  has_many   :hashtags, dependent: :delete_all
  has_many   :urls,     dependent: :delete_all
  has_many   :media,    dependent: :delete_all

  validates :tweet_id,                presence: true,  uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :in_reply_to_tweet_id,    allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :in_reply_to_twitter_id,  allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :in_reply_to_screen_name, allow_nil: true, length: { maximum: 255 }
  validates :place_full_name,         allow_nil: true, length: { maximum: 255 }
  validates :retweet_count,           allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :source,                  presence: true,  length: { maximum: 255 }
  validates :text,                    presence: true
  validates :is_retweet_before_type_cast, inclusion: { in: [1, 0, true, false] }
  with_options if: :is_retweet? do |retweet|
    retweet.validates :rt_name,        presence: true, length: { maximum: 280 }
    retweet.validates :rt_screen_name, presence: true, length: { maximum: 255 }
    retweet.validates :rt_avatar_url,  presence: true, length: { maximum: 255 }
    retweet.validates :rt_text,        presence: true
    retweet.validates :rt_source,      presence: true, length: { maximum: 255 }
    retweet.validates :rt_created_at,  presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end
  with_options unless: :is_retweet? do |tweet|
    tweet.validates :rt_name,        absence: true
    tweet.validates :rt_screen_name, absence: true
    tweet.validates :rt_avatar_url,  absence: true
    tweet.validates :rt_text,        absence: true
    tweet.validates :rt_source,      absence: true
    tweet.validates :rt_created_at,  absence: true
  end
  validates :possibly_sensitive_before_type_cast, inclusion: { in: [1, 0, true, false] }
  validates :protected_flag_before_type_cast,     inclusion: { in: [1, 0, true, false] }
  validates :tweeted_at,              presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :tweet_id_reversed,       presence: true, numericality: { only_integer: true, less_than_or_equal_to: 0 }
  validates :tweeted_at_reversed,     presence: true, numericality: { only_integer: true, less_than_or_equal_to: 0 }
  validates :tweeted_on,              presence: true

  scope :not_protected,             -> { where(protected_flag: false) }
  scope :order_by_newest_to_oldest, -> { order(tweeted_at_reversed: :asc, tweet_id_reversed: :asc) }
  scope :tweeted_at_or_before,      -> (time) do
    boundary = time.to_i
    where("tweeted_at_reversed >= ?", -1 * boundary)
  end
  scope :use_index, -> (index) { from("#{self.table_name} USE INDEX(#{index})") }

  class << self
    def most_recent_tweet_id!
      order_by_newest_to_oldest.first!.tweet_id
    end
  end

  def as_json(_options = {})
    ret = {
      tweetId:   tweet_id.to_s,
      text:      text,
      tweetedAt: Time.zone.at(tweeted_at).iso8601,
      isRetweet: is_retweet,
      urls:      (urls + media).as_json,
      user:      user.as_tweet_user_json
    }
    if is_retweet?
      ret.merge!(
        rtAvatarUrl:  rt_avatar_url,
        rtName:       rt_name,
        rtScreenName: rt_screen_name,
        rtText:       rt_text,
        rtSource:     rt_source,
        rtCreatedAt:  Time.zone.at(rt_created_at).iso8601,
      )
    end
    ret
  end
end

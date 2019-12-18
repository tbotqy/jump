# frozen_string_literal: true

class TweetImportProgress < ApplicationRecord
  belongs_to :user
  has_many   :statuses, through: :user

  validates :user_id,                   uniqueness: true
  validates :finished_before_type_cast, inclusion: { in: [1, 0, true, false] }

  after_destroy do
    current_count.delete
    last_tweet_id.delete
  end

  include Redis::Objects
  counter :current_count
  value   :last_tweet_id

  def as_json(_options = {})
    {
      percentage:  percentage,
      finished:    finished,
      lastTweetId: last_tweet_id.value
    }
  end

  def increment_by(number)
    current_count.increment(number)
  end

  def mark_as_finished!
    self.finished = true
    save!
  end

  def percentage
    calculation_result = ((current_count.value / percentage_denominator.to_f) * 100).floor
    [100, calculation_result].min
  end

  private
    def percentage_denominator
      Settings.twitter.traceable_tweet_count_limit
    end
end

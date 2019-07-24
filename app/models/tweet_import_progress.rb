# frozen_string_literal: true

class TweetImportProgress < ApplicationRecord
  belongs_to :user
  has_many   :statuses, through: :user

  validates :user_id,                   uniqueness: true
  validates :count,                     presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :finished_before_type_cast, inclusion: { in: [1, 0, true, false] }

  class << self
    def latest_by_user_id(user_id)
      where(user_id: user_id).last
    end
  end

  def as_json(_options = {})
    {
      percentage:  percentage,
      last_status: statuses.last.as_json || {},
      user:        user.as_json
    }
  end

  def increment_count!(by:)
    self.count += by
    save!
  end

  def percentage
    calculation_result = ((count / percentage_denominator.to_f) * 100).floor
    [100, calculation_result].min
  end

  private
    def percentage_denominator
      Settings.twitter.traceable_tweet_count_limit
    end
end

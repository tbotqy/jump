# frozen_string_literal: true

class TweetImportProgress < ApplicationRecord
  belongs_to :user
  has_many   :statuses, through: :user

  validates :percentage_denominator, presence: true, numericality: { only_integer: true, other_than: 0 }

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
    if [count, percentage_denominator].any?(&:negative?)
      raise "Calculating with some negative value. (count: #{count}, percentage_denominator: #{percentage_denominator})"
    end
    calculation_result = ((count / percentage_denominator.to_f) * 100).floor
    [100, calculation_result].min
  end
end

# frozen_string_literal: true

class TweetImportJobProgress < ApplicationRecord
  belongs_to :user

  validates :percentage_denominator, presence: true, numericality: { other_than: 0 }

  scope :finished, -> { where(finished: true) }
  scope :unfinished, -> { where(finished: false) }

  class << self
    def latest_by_user_id(user_id)
      where(user_id: user_id).last
    end
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

  def mark_as_finished!
    self.finished = true
    save!
  end
end

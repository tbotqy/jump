class PublishedStatusTweetedDate < ApplicationRecord
  # MEMO : This is ununsed class. Directly fetching Status#tweeted_on instead.
  validates_uniqueness_of :tweeted_on

  class << self
    def add_from_unixtime!(unixtime)
      date = Time.at(unixtime).utc.to_date
      return if date_exists?(date)
      create!(tweeted_on: date)
    end

    def all_sorted_dates
      order(tweeted_on: :desc).pluck(:tweeted_on)
    end

    private

    def date_exists?(date)
      where(tweeted_on: date).exists?
    end
  end
end

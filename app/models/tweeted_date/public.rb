# frozen_string_literal: true

class TweetedDate
  class Public
    def years
      all_dates.map(&:beginning_of_year).uniq
    end

    def months
      all_dates.map(&:beginning_of_month).uniq
    end

    def days
      all_dates
    end

    private

      def all_dates
        @all_dates ||= tweeted_unixtimes.map { |unixtime| Time.zone.at(unixtime).to_date }.uniq
      end

      def tweeted_unixtimes
        Status.not_deleted.not_private.order(twitter_created_at_reversed: :asc).pluck(:twitter_created_at)
      end
  end
end

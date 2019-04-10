# frozen_string_literal: true

class TweetedDate
  class ByUserFriend
    def initialize(user_id)
      @user_id = user_id
    end

    def years
      tweeted_dates.map(&:beginning_of_year).uniq
    end

    def months
      tweeted_dates.map(&:beginning_of_month).uniq
    end

    def days
      tweeted_dates.uniq
    end

    private

      def tweeted_dates
        @tweeted_dates ||= tweeted_unixtimes.map { |unixtime| Time.zone.at(unixtime).to_date }
      end

      def tweeted_unixtimes
        Status.ordered_tweeted_unixtimes_by_user_id(friend_user_ids)
      end

      def friend_user_ids
        User.find(@user_id).friend_user_ids
      end
  end
end

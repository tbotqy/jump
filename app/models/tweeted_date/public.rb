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
      @all_dates ||= PublishedStatusTweetedDate.all_sorted_dates
    end
  end
end

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
      @all_dates ||= Status.not_deleted.not_private.distinct(:tweeted_on).order(tweeted_on: :desc).pluck(:tweeted_on)
    end
  end
end

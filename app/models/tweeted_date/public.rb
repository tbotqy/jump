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
      @all_dates ||= all_unixtimes.map{|unixtime| Time.zone.at(unixtime).to_date}
    end

    def all_unixtimes
      @all_unixtimes ||= PublicDate.ordered_unixtimes
    end
  end
end

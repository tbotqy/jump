class PublicDate < ActiveRecord::Base
  class << self
    def add_record(unixtime_created_at)
      unless date_exists?(unixtime_created_at)
        create(
          posted_date: convert_time_to_date(unixtime_created_at),
          posted_unixtime: unixtime_created_at
        )
      end
    end

    # FIXME : make this private
    def date_exists?(unixtime_created_at)
      date = convert_time_to_date(unixtime_created_at)
      where(posted_date: date).exists?
    end

    def get_list
      select(:posted_unixtime).order('posted_unixtime DESC')
    end

    def convert_time_to_date(unixtime_created_at)
      Time.zone.at(unixtime_created_at).strftime('%Y/%-m/%-d')
    end
  end
end

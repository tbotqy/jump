class PublicDate < ActiveRecord::Base

  def self.add_record(unixtime_created_at)
    unless self.date_exists?(unixtime_created_at)
      self.create(
        :posted_date => self.convert_time_to_date(unixtime_created_at),
        :posted_unixtime => unixtime_created_at
        )
    end
  end

  def self.date_exists?(unixtime_created_at)
    date = self.convert_time_to_date(unixtime_created_at)
    self.where(:posted_date => date).exists?
  end

  def self.get_list
    self.select(:posted_unixtime).order('posted_unixtime DESC')
  end

  def self.convert_time_to_date(unixtime_created_at)
    Time.zone.at(unixtime_created_at).strftime('%Y/%-m/%-d')
  end

end

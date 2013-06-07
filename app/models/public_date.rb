class PublicDate < ActiveRecord::Base
  # attr_accessible :title, :body

  def self.add_record(created_at)
    unless self.date_exists?(created_at)
      self.create(
        :posted_date => self.convert_time_to_date(created_at),
        :posted_unixtime => created_at
        )
    end
  end

  def self.date_exists?(created_at)
    date = self.convert_time_to_date(created_at)
    self.where(:posted_date => date).exists?
  end

  def self.convert_time_to_date(created_at)
    Time.at(created_at).strftime('%Y/%-m/%-d')
  end

end

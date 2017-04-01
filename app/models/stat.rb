class Stat < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  class << self
    def active_status_count
      get_value_of(:active_status_count)
    end

    def get_value_of(dest_type_name)
      # returns the value of given type
      select(:value).find_by_type(dest_type_name).value
    end
  end

  def self.increase(dest_type_name,number_to_add)
    # increase the number of destinated data value
    dest_record = self.get_dest_record(dest_type_name)

    # add given number
    dest_record.add_value(number_to_add)
  end

  def self.decrease(dest_type_name,number_to_subtract)
    # decrease the value of destinated record with given number
    dest_record = self.get_dest_record(dest_type_name)

    # substruct given number from the value in destinated record
    dest_record.subtract_value(number_to_subtract)
  end

  def self.get_dest_record(dest_type_name)
    find_by_type(dest_type_name)
  end

  def add_value(number_to_add)
    # add given number to current record
    update_attributes(:value => (self.value + number_to_add))
  end

  def subtract_value(number_to_subtract)
    # subtruct given number from current record
    update_attributes(:value => (self.value - number_to_subtract))
  end

  def self.sync_active_status_count
    # sync the value of active status count with the count on status table
    count_on_statuses = Status.where(:deleted_flag => false).count
    self.get_dest_record("active_status_count").update_attributes(:value => count_on_statuses)
  end


end

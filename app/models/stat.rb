class Stat < ActiveRecord::Base
  attr_accessible :type, :updated_at, :value
  self.inheritance_column = :_type_disabled

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
  
end

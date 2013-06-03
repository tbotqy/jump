class Status < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :entity
  
  def self.get_total_status_num
    self.count(
      :conditions => {
        :pre_saved => false
      }
      )
  end
end

class Friend < ActiveRecord::Base
  belongs_to :user
  default_scope order('created_at DESC')

  def self.save_friends(user_id,friend_ids)
    created_at = Time.now.to_i
    
    friend_ids.each do |fid|
      self.create(
        :user_id => user_id,
        :following_twitter_id => fid,
        :created_at => created_at
        )
    end
    
    # update the time stamp in User model
    User.find(user_id) do |u|
      if u.nil?
        put "not found"
      else
        u.update_attribute(:friends_updated_at,created_at)
      end
    end
  end
  
  def self.get_list
    self.select(:following_twitter_id)
  end

  def self.update_list(user_id,friend_ids)
    # delete user's friend list
    self.destroy_all(:user_id => user_id)
    # insert new friend list
    self.save_friends(user_id,friend_ids)
  end

  def self.owned_by_current_user(user_id)
    self.where(:user_id => user_id)
  end

end

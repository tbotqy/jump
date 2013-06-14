class Friend < ActiveRecord::Base
  belongs_to :user

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

end

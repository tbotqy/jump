class FollowingTwitterId < ApplicationRecord
  belongs_to :user
  scope :user_id, ->(user_id){where(user_id: user_id)}

  class << self
    def register!(user_id, following_twitter_ids)
      following_twitter_ids.each do |following_twitter_id|
        create!(
          user_id: user_id,
          following_twitter_id: following_twitter_id,
          created_at: created_at
        )
      end

      # update the time stamp in User model
      User.find(user_id).update_attribute(:friends_updated_at, created_at)
    end
  end
end

class FollowingTwitterId < ApplicationRecord
  belongs_to :user
  scope :user_id, ->(user_id){where(user_id: user_id)}

  class << self
    def register!(user_id, following_twitter_ids)
      Array.wrap(following_twitter_ids).each do |following_twitter_id|
        create!(
          user_id: user_id,
          following_twitter_id: following_twitter_id
        )
      end

      User.find(user_id).update_attribute(:friends_updated_at, Time.now)
    end
  end
end

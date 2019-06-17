# frozen_string_literal: true

class Followee < ApplicationRecord
  belongs_to :user
  scope :user_id, ->(user_id) { where(user_id: user_id) }

  class << self
    def register!(user_id, twitter_ids)
      Array.wrap(twitter_ids).each do |twitter_id|
        create!(
          user_id: user_id,
          twitter_id: twitter_id
        )
      end

      User.find(user_id).update_attribute(:friends_updated_at, Time.now)
    end
  end
end

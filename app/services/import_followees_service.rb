# frozen_string_literal: true

class ImportFolloweesService
  private_class_method :new

  class << self
    def call!(user_id:)
      new(user_id).send(:call!)
    end
  end

  private
    def initialize(user_id)
      @user_id = user_id
    end

    attr_reader :user_id

    def call!
      delete_and_register!
      update_timestamp!
    end

    def delete_and_register!
      Followee.user_id(user_id).delete_all
      Followee.register!(user_id, fresh_friend_twitter_ids)
    end

    def update_timestamp!
      User.find(user_id).update_attribute(:friends_updated_at, Time.now.utc.to_i)
    end

    def difference_exists?
      existing_friend_twitter_ids != fresh_friend_twitter_ids
    end

    def existing_friend_twitter_ids
      @existing_friend_twitter_ids ||= Followee.user_id(user_id).pluck(:twitter_id).sort
    end

    def fresh_friend_twitter_ids
      @fresh_friend_twitter_ids ||= TwitterServiceClient::Friend.fetch_friend_twitter_ids(user_id: user_id).sort
    end
end

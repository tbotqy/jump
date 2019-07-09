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
      ActiveRecord::Base.transaction do
        renew!
        log!
      end
    end

    def renew!
      user.followees.delete_all
      fresh_twitter_ids.each { |id| user.followees.create!(twitter_id: id) }
    end

    def log!
      user.update!(friends_updated_at: Time.now.utc.to_i)
    end

    def fresh_twitter_ids
      @fresh_friend_twitter_ids ||= TwitterServiceClient::Friend.fetch_friend_twitter_ids(user_id: user_id).sort
    end

    def user
      @user ||= User.find(user_id)
    end
end

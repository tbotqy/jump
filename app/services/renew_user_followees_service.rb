# frozen_string_literal: true

class RenewUserFolloweesService
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
      fresh_twitter_ids.each { |twitter_id| user.followees.create!(twitter_id: twitter_id) }
    end

    def log!
      user.update!(friends_updated_at: now)
    end

    def fresh_twitter_ids
      FetchUserFolloweesService.call!(user_id: user_id)
    end

    def user
      @user ||= User.find(user_id)
    end

    def now
      Time.now.utc.to_i
    end
end

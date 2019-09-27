# frozen_string_literal: true

class RenewUserFolloweesService
  include UserTwitterClient
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
      renew!
    end

    def renew!
      ActiveRecord::Base.transaction do
        user.followees.delete_all
        fresh_twitter_ids.each { |twitter_id| user.followees.create!(twitter_id: twitter_id) }
      end
    end

    def fresh_twitter_ids
      user_twitter_client.collect_followee_ids
    end

    def user
      @user ||= User.find(user_id)
    end
end

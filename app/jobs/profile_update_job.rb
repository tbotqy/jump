# frozen_string_literal: true

class ProfileUpdateJob < ApplicationJob
  queue_as :default

  def perform
    target_user_ids.each do |user_id|
      UpdateUserAccountService.call!(user_id: user_id)
    rescue Twitter::Error => twitter_error
      # TODO: include to service class
      ProfileUpdateFailLog.log!(user_id, twitter_error.message)
      next
    end
  end

  private
    def target_user_ids
      failed_user_ids = ProfileUpdateFailLog.pluck(:user_id)
      User.where.not(id: failed_user_ids).pluck(:id)
    end
end

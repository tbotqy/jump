class ProfileUpdateJob < ApplicationJob
  queue_as :default

  def perform
    target_user_ids.each do |user_id|
      begin
        ProfileUpdateProcess.call!(user_id)
      rescue Twitter::Error => twitter_error
        ProfileUpdateFailLog.log!(user_id, twitter_error.message)
        next
      rescue => e
        ExceptionNotifier.notify_exception(e)
        exit
      end
    end
  end

  private

  def target_user_ids
    failed_user_ids = ProfileUpdateFailLog.pluck(:user_id)
    User.where.not(id: failed_user_ids).active.pluck(:id)
  end
end

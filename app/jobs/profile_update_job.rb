class ProfileUpdateJob < ApplicationJob
  queue_as :default

  def perform
    User.active.pluck(:id).each do |user_id|
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
end

class FriendImportJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    PullFolloweesService.call!(user_id)
  end
end

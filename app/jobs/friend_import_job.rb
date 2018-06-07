class FriendImportJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    FriendImportProcess.initial_import!(user_id)
  end
end

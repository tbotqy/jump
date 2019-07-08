# frozen_string_literal: true

class FriendImportJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    ImportFriendService.call!(user_id: user_id)
  end
end

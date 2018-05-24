class FriendImportJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    friend_twitter_ids = TwitterServiceClient::Friend.fetch_friend_twitter_ids(user_id: user_id)
    FollowingTwitterId.save_friends(user_id, friend_twitter_ids)
  end
end

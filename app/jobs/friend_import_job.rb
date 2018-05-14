class FriendImportJob < ActiveJob::Base
  queue_as :default

  def perform(user_id:)
    friend_twitter_ids = TwitterServiceClient::Friend.fetch_friend_twitter_ids(user_id: user_id)
    Friend.save_friends(user_id, friend_twitter_ids)
  end
end

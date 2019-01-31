class TweetImportJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    ImportTweetsService.call!(user_id)
  end
end

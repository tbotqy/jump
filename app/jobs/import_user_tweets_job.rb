# frozen_string_literal: true

class ImportUserTweetsJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    @user_id = user_id
    import!
  end

  private
    attr_reader :user_id

    def import!
      oldest_id_of_all_fetched_tweets = nil
      loop do
        tweets = FetchUserTweetsService.call!(user_id: user_id, tweeted_before_id: oldest_id_of_all_fetched_tweets)
        break if tweets.blank?
        register_unregistered_tweets!(tweets)
        update_progress!(tweets.count)

        # specify for subsequent fetch
        # oldest_id_of_all_fetched_tweets gets smaller
        oldest_id_of_all_fetched_tweets = tweets.last.id
      end
      record_timestamp!
      update_summary
      destroy_progress!
    end

    def register_unregistered_tweets!(tweets)
      tweets.each { |tweet| RegisterTweetService.call!(tweet: tweet) unless Status.exists?(tweet_id: tweet.id) }
    end

    def update_progress!(tweet_count_additionally_imported)
      progress.increment_count!(by: tweet_count_additionally_imported)
    end

    def destroy_progress!
      progress.destroy!
    end

    def record_timestamp!
      user.update!(statuses_updated_at: Time.now.utc.to_i)
    end

    def update_summary
      ActiveStatusCount.increment_by(progress.count)
    end

    def progress
      @progress ||= user.build_tweet_import_progress
    end

    def user
      @user ||= User.find(user_id)
    end
end

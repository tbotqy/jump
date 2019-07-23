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
        register_unregistered_tweets!(fetched_tweets: tweets)
        update_progress!(fetched_tweets_count: tweets.count)

        # specify for subsequent fetch
        # oldest_id_of_all_fetched_tweets gets smaller
        oldest_id_of_all_fetched_tweets = tweets.last.id
      end
      record_timestamp!
      update_summary
      close_progress!
    end

    def register_unregistered_tweets!(fetched_tweets:)
      fetched_tweets.each { |fetched_tweet| RegisterTweetService.call!(tweet: fetched_tweet) unless Status.exists?(tweet_id: fetched_tweet.id) }
    end

    def update_progress!(fetched_tweets_count:)
      progress.increment_count!(by: fetched_tweets_count)
    end

    def record_timestamp!
      user.update!(statuses_updated_at: Time.now.utc.to_i)
    end

    def update_summary
      ActiveStatusCount.increment_by(progress.count)
    end

    def close_progress!
      progress.mark_as_finished!
    end

    def progress
      @progress ||= user.build_tweet_import_progress(percentage_denominator: estimated_number_of_tweets_to_be_imported)
    end

    def user
      @user ||= User.find(user_id)
    end

    def estimated_number_of_tweets_to_be_imported
      CalculateAcquirableTweetCountService.call!(user_id: user_id)
    end
end

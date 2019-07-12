# frozen_string_literal: true

class ImportTweetsJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    @user_id = user_id
    initialize_parameter!
    import!
  end

  private
    attr_reader :user_id

    def initialize_parameter!
      if user.has_any_status?
        @initial_most_recent_tweet_id = user.statuses.most_recent_tweet_id!
      else
        @initial_most_recent_tweet_id = nil
      end
    end

    def import!
      oldest_id_of_all_fetched_tweets = nil
      loop do
        tweets = FetchUserTweetsService.call!(user_id: user_id, tweeted_after_id: @initial_most_recent_tweet_id, tweeted_before_id: oldest_id_of_all_fetched_tweets)
        break if tweets.blank?
        save_tweets!(tweets)
        record_progress!(tweets.count)

        # specify for subsequent fetch
        # oldest_id_of_all_fetched_tweets gets smaller
        oldest_id_of_all_fetched_tweets = tweets.last.id
      end
      close_progress!
      update_summary
    end

    def save_tweets!(tweets)
      Status.save_tweets!(user_id, tweets)
    end

    def record_progress!(tweet_count_additionally_imported)
      job_progress.increment_count!(by: tweet_count_additionally_imported)
    end

    def close_progress!
      job_progress.mark_as_finished!
    end

    def update_summary
      ActiveStatusCount.increment_by(job_progress.count)
    end

    def job_progress
      @job_progress ||= TweetImportJobProgress.new(job_id: job_id, user_id: user_id, percentage_denominator: estimated_number_of_tweets_to_be_imported)
    end

    def user
      @user ||= User.find(user_id)
    end

    def estimated_number_of_tweets_to_be_imported
      CalculateAcquirableTweetCountService.call!(user_id: user_id)
    end
end

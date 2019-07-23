# frozen_string_literal: true

class ImportUserTweetsJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    @user_id = user_id
    initialize_parameter!
    import!
    finalize!
  end

  private
    attr_reader :user_id, :tweeted_after_id

    def initialize_parameter!
      if user.statuses.exists?
        @tweeted_after_id = user.statuses.most_recent_tweet_id!
      else
        @tweeted_after_id = nil
      end
    end

    def import!
      ActiveRecord::Base.transaction do
        tweeted_before_id = nil
        loop do
          tweets = FetchUserTweetsService.call!(user_id: user_id, tweeted_after_id: tweeted_after_id, tweeted_before_id: tweeted_before_id)
          break if tweets.blank?
          register_tweets!(tweets)
          update_progress!(tweets.count)

          # specify for subsequent fetch
          # tweeted_before_id gets smaller
          tweeted_before_id = tweets.last.id
        end
      end
    end

    def finalize!
      user.update!(statuses_updated_at: Time.now.utc.to_i)
      ActiveStatusCount.increment_by(progress.count)
      progress.mark_as_finished!
    end

    def register_tweets!(tweets)
      tweets.each { |tweet| RegisterTweetService.call!(tweet: tweet) }
    end

    def update_progress!(registered_tweet_count)
      progress.increment!(:count, registered_tweet_count)
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

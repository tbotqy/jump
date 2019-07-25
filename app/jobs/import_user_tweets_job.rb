# frozen_string_literal: true

class ImportUserTweetsJob < ApplicationJob
  include UserTwitterClient
  queue_as :default

  def perform(user_id:)
    @user_id = user_id
    import!
  end

  private
    attr_reader :user_id

    def import!
      user_twitter_client.collect_tweets_in_batches do |tweets|
        register_unregistered_tweets!(tweets)
        update_progress!(tweets.count)
      end
      record_timestamp!
      update_summary
      close_progress!
    end

    def register_unregistered_tweets!(tweets)
      tweets.each { |tweet| RegisterTweetService.call!(tweet: tweet) unless Status.exists?(tweet_id: tweet.id) }
    end

    def update_progress!(tweet_count_additionally_imported)
      progress.increment_count!(by: tweet_count_additionally_imported)
    end

    def close_progress!
      progress.mark_as_finished!
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

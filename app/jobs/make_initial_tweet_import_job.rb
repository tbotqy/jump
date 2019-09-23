# frozen_string_literal: true

class MakeInitialTweetImportJob < ApplicationJob
  include UserTwitterClient
  queue_as :default

  def perform(user_id:)
    @user_id = user_id
    ensure_initial_import!
    initialize_progress!
    operate!
  end

  private
    attr_reader :user_id, :progress

    def ensure_initial_import!
      if user.has_any_status?
        raise "This job is intended to be called for initial import, but user already has some statuses."
      end
    end

    def initialize_progress!
      user.build_tweet_import_progress(finished: false).save!
      @progress = user.tweet_import_progress
    end

    def operate!
      ActiveRecord::Base.transaction do
        import!
        finalize!
      end
    rescue => e
      progress.destroy!
      raise e
    end

    def import!
      user_twitter_client.collect_tweets_in_batches do |tweets|
        tweets.each { |tweet| RegisterTweetService.call!(tweet: tweet) }
        progress.increment_by(tweets.count)
        progress.last_tweet_id = tweets.last.id
      end
    end

    def finalize!
      user.update!(statuses_updated_at: Time.current.to_i)
      progress.mark_as_finished!
      ActiveStatusCount.increment_by(progress.current_count.value)
    end

    def user
      @user ||= User.find(user_id)
    end
end

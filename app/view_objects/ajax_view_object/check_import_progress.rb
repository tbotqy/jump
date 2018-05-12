module AjaxViewObject
  class CheckImportProgress
    def initialize(user_id:)
      @user_id = user_id
    end

    def as_hash
      {
        job_started: job_progress.present?,
        count: job_progress&.count,
        finished: job_progress&.finished? || false,
        tweet_text: user_last_status_text,
        tweet_date: tweet_date_text
      }
    end

    private

    def user_newest_status_text
      return if user_newest_status.blank?
      user_newest_status.text
    end

    def user_last_status_text
      user_last_status&.text
    end

    def tweet_date_text
      return if user_last_status.blank?
      Time.zone.at(user_last_status.twitter_created_at).strftime("%Y年%m月%d日 - %H:%M")
    end

    def job_progress_count_text
      return if job_progress.blank?
      job_progress.count.to_s(:delimited)
    end

    def job_progress
      @job_progress ||= TweetImportJobProgress.latest_by_user_id(@user_id)
    end

    def user_last_status
      @user_last_status ||= user.last_status
    end

    def user
      User.find(@user_id)
    end
  end
end

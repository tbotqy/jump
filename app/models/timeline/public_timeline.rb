# frozen_string_literal: true

class Timeline
  class PublicTimeline < Base
    def title
      return "パブリックタイムライン" unless target_date.specified?
      "#{target_date.formatted_date}のパブリックタイムライン"
    end

    def source_statuses
      if target_date.specified?
        Status.not_private.tweeted_in(target_date.date_string, PER_PAGE)
      elsif @largest_tweet_id.present?
        # fetch statuses whose tweet_id is equal to or smaller than @largest_tweet_id
        Status
          .not_private
          .get_older_status_by_tweet_id(@largest_tweet_id, PER_PAGE)
      else
        Status.not_private.get_latest_status(PER_PAGE)
      end
    end

    private

      def older_status
        Status.not_private.get_older_status_by_tweet_id(oldest_tweet_id, 1)
      end
  end
end

# frozen_string_literal: true

class Timeline
  class UserTimeline < Base
    def title
      base_text = "#{@timeline_owner.name}(@#{@timeline_owner.screen_name}) さんのツイート"
      return base_text unless target_date.specified?
      "#{target_date.formatted_date}の #{base_text}"
    end

    def source_statuses
      if target_date.specified?
        # fetch statuses in specified date
        Status
          .tweeted_in(target_date.date_string, PER_PAGE)
          .tweeted_by(@timeline_owner.id)
      elsif @largest_tweet_id.present?
        # fetch statuses whose tweet_id is equal to or smaller than @largest_tweet_id
        Status
          .get_older_status_by_tweet_id(@largest_tweet_id, PER_PAGE)
          .tweeted_by(@timeline_owner.id)
      else
        # just fetch latest statuses
        Status.get_latest_status(PER_PAGE).tweeted_by(@timeline_owner.id)
      end
    end

    private

      def older_status
        Status.get_older_status_by_tweet_id(oldest_tweet_id, 1).tweeted_by(@timeline_owner.id)
      end
  end
end

module Timeline
  class PublicTimeline < Base
    def title
      return "パブリックタイムライン" unless target_date.specified?
      "#{target_date.formatted_date}のパブリックタイムライン"
    end

    def source_statuses
      if target_date.specified?
        Status.not_deleted.get_status_in_date(target_date.date_string, PER_PAGE)
      else
        Status.not_deleted.get_latest_status(PER_PAGE)
      end
    end

    private

    def older_status
      Status.not_deleted.get_older_status_by_tweet_id(oldest_tweet_id, 1)
    end
  end
end

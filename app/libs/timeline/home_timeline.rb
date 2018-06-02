module Timeline
  class HomeTimeline < Base
    def title
      base_text = "#{@timeline_owner.name}(@#{@timeline_owner.screen_name}) さんのホームタイムライン"
      return base_text unless target_date.specified?
      "#{target_date.formatted_date}の #{base_text}"
    end

    def source_statuses
      if target_date.specified?
        # fetch statuses in specified date
        Status
          .not_private
          .get_status_in_date(target_date.date_string, PER_PAGE)
          .owned_by_friend_of(@timeline_owner.id)
      else
        # just fetch latest statuses
        Status
          .not_private
          .force_index(:idx_u_tcar_sisr_on_statuses)
          .get_latest_status(PER_PAGE).owned_by_friend_of(@timeline_owner.id)
      end
    end

    private

    def older_status
      Status
        .not_private
        .force_index(:idx_u_on_statuses)
        .get_older_status_by_tweet_id(oldest_tweet_id, 1)
        .owned_by_friend_of(@timeline_owner.id)
    end
  end
end

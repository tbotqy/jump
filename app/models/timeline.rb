# frozen_string_literal: true

class Timeline
  class << self
    def user_timeline(date:, timeline_owner:)
      by_type_and_date(
        type: TimelineType.new("user_timeline"),
        date: date,
        timeline_owner: timeline_owner
      )
    end

    def home_timeline(date:, timeline_owner:)
      by_type_and_date(
        type: TimelineType.new("home_timeline"),
        date: date,
        timeline_owner: timeline_owner
      )
    end

    def public_timeline(date:)
      by_type_and_date(
        type: TimelineType.new("public_timeline"),
        date: date,
        timeline_owner: nil
      )
    end

    def read_more(type:, prev_oldest_tweet_id:, timeline_owner:)
      target_timeline(type).new(date_string: nil, largest_tweet_id: prev_oldest_tweet_id - 1, timeline_owner: timeline_owner)
    end

    def by_type_and_date(type:, date:, timeline_owner:)
      target_timeline(type).new(date_string: date, largest_tweet_id: nil, timeline_owner: timeline_owner)
    end

    private

      def target_timeline(timeline_type)
        case
        when timeline_type.public_timeline?
          Timeline::PublicTimeline
        when timeline_type.home_timeline?
          Timeline::HomeTimeline
        when timeline_type.user_timeline?
          Timeline::UserTimeline
        end
      end
  end
end

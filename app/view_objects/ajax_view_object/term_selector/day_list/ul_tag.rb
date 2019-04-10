# frozen_string_literal: true

module AjaxViewObject
  class TermSelector
    class DayList::UlTag
      def initialize(target_month:, target_days:, link_path_without_date:)
        @target_month = target_month
        @target_days = target_days
        @link_path_without_date = link_path_without_date
      end

      def class_text
        "date-#{@target_month.strftime("%Y-%-m")}"
      end

      def li_tags
        @target_days.map.with_index do |target_day, i|
          AjaxViewObject::TermSelector::DayList::LiTag.new(
            target_day: target_day,
            index: i,
            link_path_without_date: @link_path_without_date,
            total_li_count_in_ul: target_days_count
          )
        end
      end

      private

        def target_days_count
          @target_days_count ||= @target_days.count
        end
    end
  end
end

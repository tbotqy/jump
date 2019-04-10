# frozen_string_literal: true

module AjaxViewObject
  class TermSelector
    class DayList
      def initialize(target_days:, link_path_without_date:)
        @target_days = target_days
        @link_path_without_date = link_path_without_date
      end

      def ul_tags
        days_by_month.map do |month, days|
          AjaxViewObject::TermSelector::DayList::UlTag.new(target_month: month, target_days: days, link_path_without_date: @link_path_without_date)
        end
      end

      private

        def days_by_month
          @target_days.group_by(&:beginning_of_month)
        end
    end
  end
end

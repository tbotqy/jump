# frozen_string_literal: true

module AjaxViewObject
  class TermSelector
    class MonthList::UlTag
      def initialize(target_year:, target_months:, link_path_without_date:)
        @target_year = target_year
        @target_months = target_months
        @link_path_without_date = link_path_without_date
      end

      def class_text
        "date-#{@target_year.year}"
      end

      def li_tags
        @target_months.map.with_index do |target_month, i|
          AjaxViewObject::TermSelector::MonthList::LiTag.new(
            target_month: target_month,
            index: i,
            link_path_without_date: @link_path_without_date,
            total_li_count_in_ul: target_months_count
          )
        end
      end

      private

        def target_months_count
          @target_months_count ||= @target_months.count
        end
    end
  end
end

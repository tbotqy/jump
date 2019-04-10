# frozen_string_literal: true

module AjaxViewObject
  class TermSelector
    class YearList
      def initialize(target_years:, link_path_without_date:)
        @target_years = target_years
        @link_path_without_date = link_path_without_date
      end

      def li_tags
        @target_years.map.with_index do |target_year, i|
          AjaxViewObject::TermSelector::YearList::LiTag.new(
            target_year: target_year,
            index: i,
            link_path_without_date: @link_path_without_date,
            total_li_count_in_ul: target_years_count
          )
        end
      end

      private

        def target_years_count
          @target_years_count ||= @target_years.count
        end
    end
  end
end

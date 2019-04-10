# frozen_string_literal: true

module AjaxViewObject
  class TermSelector
    class MonthList
      def initialize(target_months:, link_path_without_date:)
        @target_months = target_months
        @link_path_without_date = link_path_without_date
      end

      def ul_tags
        months_by_year.map do |year, months|
          AjaxViewObject::TermSelector::MonthList::UlTag.new(target_year: year, target_months: months, link_path_without_date: @link_path_without_date)
        end
      end

      private

        def months_by_year
          @target_months.group_by(&:beginning_of_year)
        end
    end
  end
end

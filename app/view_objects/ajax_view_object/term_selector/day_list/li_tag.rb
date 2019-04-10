# frozen_string_literal: true

module AjaxViewObject
  class TermSelector
    class DayList::LiTag
      delegate :year, :month, :day, to: :@target_day

      def initialize(target_day:, index:, link_path_without_date:, total_li_count_in_ul:)
        @target_day = target_day
        @index = index
        @link_path_without_date = link_path_without_date
        @total_li_count_in_ul = total_li_count_in_ul
      end

      def data_date_value
        "#{year}-#{month}-#{day}"
      end

      def anchor_text
        day
      end

      def anchor_href
        "#{@link_path_without_date}/#{year}-#{month}-#{day}"
      end

      def data_complete_text_value
        day
      end

      def anchor_class_text
        AjaxViewObject::TermSelector.li_tag_class_text(index: @index, total_li_count_in_ul: @total_li_count_in_ul)
      end
    end
  end
end

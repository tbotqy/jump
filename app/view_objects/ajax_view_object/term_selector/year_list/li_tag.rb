# frozen_string_literal: true

module AjaxViewObject
  class TermSelector
    class YearList::LiTag
      delegate :year, to: :@target_year

      def initialize(target_year:, index:, link_path_without_date:, total_li_count_in_ul:)
        @target_year = target_year
        @index = index
        @link_path_without_date = link_path_without_date
        @total_li_count_in_ul = total_li_count_in_ul
      end

      def data_date_value
        year
      end

      def anchor_text
        year
      end

      def anchor_href
        "#{@link_path_without_date}/#{year}"
      end

      def data_complete_text_value
        year
      end

      def anchor_class_text
        AjaxViewObject::TermSelector.li_tag_class_text(index: @index, total_li_count_in_ul: @total_li_count_in_ul)
      end
    end
  end
end

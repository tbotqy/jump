# frozen_string_literal: true

module AjaxViewObject
  class TermSelector
    class MonthList::LiTag
      delegate :year, :month, to: :@target_month

      def initialize(target_month:, index:, link_path_without_date:, total_li_count_in_ul:)
        @target_month = target_month
        @index = index
        @link_path_without_date = link_path_without_date
        @total_li_count_in_ul = total_li_count_in_ul
      end

      def data_date_value
        "#{year}-#{month}"
      end

      def anchor_text
        month
      end

      def anchor_href
        "#{@link_path_without_date}/#{year}-#{month}"
      end

      def data_complete_text_value
        month
      end

      def anchor_class_text
        AjaxViewObject::TermSelector.li_tag_class_text(index: @index, total_li_count_in_ul: @total_li_count_in_ul)
      end
    end
  end
end

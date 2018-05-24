module AjaxViewObject
  class TermSelector
    class << self
      def li_tag_class_text(index:, total_li_count_in_ul:)
        return 'first last' if total_li_count_in_ul == 1
        case index
        when 0
          'first'
        when total_li_count_in_ul - 1
          'last'
        else
          'mid'
        end
      end
    end

    include Rails.application.routes.url_helpers
    delegate :years, :months, :days, to: :tweeted_date

    def initialize(timeline_type, user_id)
      @timeline_type = timeline_type
      @user_id       = user_id
    end

    def year_list
      AjaxViewObject::TermSelector::YearList.new(target_years: years, link_path_without_date: link_path_without_date)
    end

    def month_list
      AjaxViewObject::TermSelector::MonthList.new(target_months: months, link_path_without_date: link_path_without_date)
    end

    def day_list
      AjaxViewObject::TermSelector::DayList.new(target_days: days, link_path_without_date: link_path_without_date)
    end

    private

    def tweeted_date
      @tweeted_date ||= TweetedDate.by(@timeline_type, @user_id)
    end

    def link_path_without_date
      case
      when @timeline_type.public_timeline?
        public_timeline_path
      when @timeline_type.user_timeline?
        user_timeline_path
      when @timeline_type.home_timeline?
        home_timeline_path
      else
        raise "Unexpected timeline type(#{@timeline_type}) given."
      end
    end
  end
end

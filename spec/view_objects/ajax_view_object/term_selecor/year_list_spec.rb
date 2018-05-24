require 'rails_helper'

describe AjaxViewObject::TermSelector::YearList do
  let(:year_list){AjaxViewObject::TermSelector::YearList.new(target_years: target_years, link_path_without_date: "/user_timeline")}
  let(:target_year_count){10}
  let(:target_years) do
    [].tap do |ret|
      target_year_count.times do |years_ago|
        ret << Date.today.beginning_of_year - years_ago.years
      end
    end
  end

  describe "#li_tags" do
    subject{year_list.li_tags}
    it "holds as much items as target_years has" do
      is_expected.to satisfy{|subject| subject.count == target_year_count}
    end
  end
end

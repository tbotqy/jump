require 'rails_helper'

describe AjaxViewObject::TermSelector::MonthList do
  let(:month_list){AjaxViewObject::TermSelector::MonthList.new(target_months: target_months, link_path_without_date: "/user_timeline")}
  let(:target_months) do
    [
      Date.new(2017,1,1),
      Date.new(2017,2,1),
      Date.new(2017,3,1),
      Date.new(2018,1,1),
      Date.new(2018,2,1),
      Date.new(2018,8,1)
    ]
  end

  describe "#ul_tags" do
    subject{month_list.ul_tags}
    it "holds as much as target_months.map(&:beginning_of_year).uniq.count of items" do
      is_expected.to satisfy{|subject| subject.count == target_months.map(&:beginning_of_year).uniq.count}
    end
  end
end

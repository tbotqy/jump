# frozen_string_literal: true

require "rails_helper"

describe AjaxViewObject::TermSelector::DayList do
  let(:day_list) { AjaxViewObject::TermSelector::DayList.new(target_days: target_days, link_path_without_date: "/user_timeline") }
  let(:target_days) do
    [
      Date.new(2017, 1, 1),
      Date.new(2017, 1, 5),
      Date.new(2017, 2, 1),
      Date.new(2017, 2, 2),
      Date.new(2017, 2, 3),
      Date.new(2017, 3, 3),
      Date.new(2018, 1, 2),
      Date.new(2018, 1, 30),
      Date.new(2018, 2, 1),
      Date.new(2018, 8, 1),
      Date.new(2018, 8, 11)
    ]
  end

  describe "#ul_tags" do
    subject { day_list.ul_tags }
    it "holds as much as target_days.map(&:beginning_of_month).uniq.count of items" do
      is_expected.to satisfy { |subject| subject.count == target_days.map(&:beginning_of_month).uniq.count }
    end
  end
end

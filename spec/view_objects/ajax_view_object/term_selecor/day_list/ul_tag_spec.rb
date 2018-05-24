require 'rails_helper'

describe AjaxViewObject::TermSelector::DayList::UlTag do
  let(:ul_tag) do
    AjaxViewObject::TermSelector::DayList::UlTag.new(
      target_month: target_month,
      target_days: target_days,
      link_path_without_date: link_path_without_date,
    )
  end
  let(:target_month){Date.today.beginning_of_month}
  let(:target_days) do
    [
      Date.new(target_month.year, target_month.month, 1),
      Date.new(target_month.year, target_month.month, 10),
      Date.new(target_month.year, target_month.month, 20)
    ]
  end
  let(:link_path_without_date){"/user_timeline"}

  describe "#class_text" do
    subject{ul_tag.class_text}
    it{is_expected.to eq "date-#{target_month.strftime("%Y-%-m")}"}
  end

  describe "#li_tags" do
    subject{ul_tag.li_tags}
    it "holds as much items as target_days has" do
      is_expected.to satisfy{|subject| subject.count == target_days.count}
    end
  end
end

require 'rails_helper'

describe AjaxViewObject::TermSelector::MonthList::UlTag do
  let(:ul_tag) do
    AjaxViewObject::TermSelector::MonthList::UlTag.new(
      target_year: target_year,
      target_months: target_months,
      link_path_without_date: link_path_without_date,
    )
  end
  let(:target_year){Date.today.beginning_of_year}
  let(:target_months) do
    [
      Date.new(target_year.year, 1, 1),
      Date.new(target_year.year, 2, 1),
      Date.new(target_year.year, 5, 1)
    ]
  end
  let(:link_path_without_date){"/user_timeline"}

  describe "#class_text" do
    subject{ul_tag.class_text}
    it{is_expected.to eq "date-#{target_year.year}"}
  end

  describe "#li_tags" do
    subject{ul_tag.li_tags}
    it "holds as much items as target_months has" do
      is_expected.to satisfy{|subject| subject.count == target_months.count}
    end
  end
end

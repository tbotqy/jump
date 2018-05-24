require 'rails_helper'

describe AjaxViewObject::TermSelector::DayList::LiTag do
  let(:li_tag) do
    AjaxViewObject::TermSelector::DayList::LiTag.new(
      target_day: target_day,
      index: index,
      link_path_without_date: link_path_without_date,
      total_li_count_in_ul: total_li_count_in_ul
    )
  end
  let(:target_day){Date.today}
  let(:index){0}
  let(:link_path_without_date){"/user_timeline"}
  let(:total_li_count_in_ul){10}

  describe "#data_date_value" do
    subject{li_tag.data_date_value}
    it{is_expected.to eq target_day.strftime("%Y-%-m-%-d")}
  end

  describe "#data_complete_text_value" do
    subject{li_tag.data_complete_text_value}
    it{is_expected.to eq target_day.day}
  end

  describe "#anchor_class_text" do
    subject{li_tag.anchor_class_text}
    context "ul tag holds just one li tag" do
      let(:total_li_count_in_ul){1}
      it{is_expected.to eq "first last"}
    end

    context "ul tag holds some numbers(10 in this case) of li tags" do
      let(:total_li_count_in_ul){10}
      context "indexed at first position" do
        let(:index){0}
        it{is_expected.to eq "first"}
      end
      context "indexed at last position" do
        let(:index){total_li_count_in_ul - 1}
        it{is_expected.to eq "last"}
      end
      context "indexed at neither first nor last position" do
        let(:index){(1...(total_li_count_in_ul - 1)).to_a.sample}
        it{is_expected.to eq "mid"}
      end
    end
  end

  describe "#anchor_text" do
    subject{li_tag.anchor_text}
    it{is_expected.to eq target_day.day}
  end

  describe "#anchor_href" do
    subject{li_tag.anchor_href}
    it{is_expected.to eq "#{link_path_without_date}/#{target_day.strftime("%Y-%-m-%-d")}"}
  end
end

# frozen_string_literal: true

require "rails_helper"

describe Status do
  describe ".tweeted_in" do
    subject { Status.tweeted_in(date_string) }
    context "only year is given" do
      let(:date_string) { "2019" }
      let!(:status_2018_12_31) { create(:status, twitter_created_at: Time.zone.local(2018, 12, 31, 23, 59, 59).to_i) }
      let!(:status_2019_1_1)   { create(:status, twitter_created_at: Time.zone.local(2019,  1,  1).to_i) }
      let!(:status_2019_12_31) { create(:status, twitter_created_at: Time.zone.local(2019, 12, 31, 23, 59, 59).to_i) }
      let!(:status_2020_1_1)   { create(:status, twitter_created_at: Time.zone.local(2020,  1,  1).to_i) }
      it "covers specified year" do
        is_expected.to contain_exactly(status_2019_1_1, status_2019_12_31)
      end
    end
    context "year and month are given" do
      let(:date_string) { "2019-5" }
      let!(:status_2019_4_30) { create(:status, twitter_created_at: Time.zone.local(2019, 4, 30, 23, 59, 59).to_i) }
      let!(:status_2019_5_1)  { create(:status, twitter_created_at: Time.zone.local(2019, 5,  1).to_i) }
      let!(:status_2019_5_31) { create(:status, twitter_created_at: Time.zone.local(2019, 5, 31, 23, 59, 59).to_i) }
      let!(:status_2019_6_1)  { create(:status, twitter_created_at: Time.zone.local(2019, 6,  1).to_i) }
      it "covers specified month" do
        is_expected.to contain_exactly(status_2019_5_1, status_2019_5_31)
      end
    end
    context "year and month and day are given" do
      let(:date_string) { "2019-5-2" }
      let!(:status_2019_5_1_23_59) { create(:status, twitter_created_at: Time.zone.local(2019, 5, 1, 23, 59, 59).to_i) }
      let!(:status_2019_5_2_0_0)   { create(:status, twitter_created_at: Time.zone.local(2019, 5, 2).to_i) }
      let!(:status_2019_5_2_23_59) { create(:status, twitter_created_at: Time.zone.local(2019, 5, 2, 23, 59, 59).to_i) }
      let!(:status_2019_5_3_0_0)   { create(:status, twitter_created_at: Time.zone.local(2019, 5, 3).to_i) }
      it "covers specified day" do
        is_expected.to contain_exactly(status_2019_5_2_0_0, status_2019_5_2_23_59)
      end
    end
  end

  describe ".date_range_of" do
    subject { Status.send(:date_range_of, date_string) }
    context "only year is given" do
      let(:date_string) { "2019" }
      it "covers specified year" do
        is_expected.to eq Time.zone.local(2019).all_year
      end
    end
    context "year and month are given" do
      let(:date_string) { "2019-5" }
      it "covers specified month" do
        is_expected.to eq Time.zone.local(2019, 5).all_month
      end
    end
    context "year and month and day are given" do
      let(:date_string) { "2019-5-2" }
      it "covers specified day" do
        is_expected.to eq Time.zone.local(2019, 5, 2).all_day
      end
    end
  end
end

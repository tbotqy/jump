# frozen_string_literal: true

require "rails_helper"

describe Status do
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

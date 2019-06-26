# frozen_string_literal: true

require "rails_helper"

def presence_of(obj)
  return "nil " if obj.nil?
  return "blank string" if obj == ""
  obj
end

describe CollectUserStatusesService::DateParser do
  describe "#date_specified?" do
    subject { described_class.new(year, month, day).date_specified? }

    context "any of year, month, day is present" do
      context "the params that seem to be valid as a date is given" do
        context "2019" do
          let(:year)  { 2019 }
          let(:month) { nil }
          let(:day)   { nil }
          it { is_expected.to eq true }
        end
        context "2019/1" do
          let(:year)  { 2019 }
          let(:month) { 1 }
          let(:day)   { nil }
          it { is_expected.to eq true }
        end
        context "2019/1/1" do
          let(:year)  { 2019 }
          let(:month) { 1 }
          let(:day)   { 1 }
          it { is_expected.to eq true }
        end
      end
      context "the params that seem to be invalid as a date is given" do
        describe "it responds with 'true' since this method is not responsible for validating the validity of params as a date" do
          context "nil/nil/1" do
            let(:year)  { nil }
            let(:month) { 1 }
            let(:day)   { 1 }
            it { is_expected.to eq true }
          end
          context "nil/1/nil" do
            let(:year)  { nil }
            let(:month) { 1 }
            let(:day)   { nil }
            it { is_expected.to eq true }
          end
          context "2019/nil/nil" do
            let(:year)  { 2019 }
            let(:month) { nil }
            let(:day)   { nil }
            it { is_expected.to eq true }
          end
          context "2019/nil/1" do
            let(:year)  { 2019 }
            let(:month) { nil }
            let(:day)   { 1 }
            it { is_expected.to eq true }
          end
        end
      end
    end

    context "none of year, month, day is present" do
      let(:year)  { nil }
      let(:month) { nil }
      let(:day)   { nil }
      it { is_expected.to eq false }
    end
  end

  describe "#last_moment_of_params!" do
    subject { described_class.new(year, month, day).last_moment_of_params! }

    shared_examples "raises error" do
      it { expect { subject }.to raise_error(Errors::InvalidParam, "Given date(year: #{year}, month: #{month}, day: #{day}) is incomplete to be parsed to Time.") }
    end

    shared_examples "returns end of given day" do
      it { is_expected.to eq Time.local(year, month, day).end_of_day }
    end

    shared_examples "returns end of given month" do
      it { is_expected.to eq Time.local(year, month).end_of_month }
    end

    shared_examples "returns end of given year" do
      it { is_expected.to eq Time.local(year).end_of_year }
    end

    context "year: 2019" do
      let(:year) { 2019 }
      context "month: 3" do
        let(:month) { 3 }
        context "day: 7" do
          let(:day) { 7 }
          it_behaves_like "returns end of given day"
        end
        context "day: nil" do
          let(:day) { nil }
          it_behaves_like "returns end of given month"
        end
        context "day: blank string" do
          let(:day) { "" }
          it_behaves_like "returns end of given month"
        end
      end
      context "month: nil" do
        let(:month) { nil }
        context "day: 7" do
          let(:day) { 7 }
          it_behaves_like "raises error"
        end
        context "day: nil" do
          let(:day) { nil }
          it_behaves_like "returns end of given year"
        end
        context "day: blank string" do
          let(:day) { "" }
          it_behaves_like "returns end of given year"
        end
      end
      context "month: blank string" do
        let(:month) { "" }
        context "day: 7" do
          let(:day) { 7 }
          it_behaves_like "raises error"
        end
        context "day: nil" do
          let(:day) { nil }
          it_behaves_like "returns end of given year"
        end
        context "day: blank string" do
          let(:day) { "" }
          it_behaves_like "returns end of given year"
        end
      end
    end

    [nil, ""].each do |year|
      context "year: #{presence_of(year)}" do
        [3, nil, ""].each do |month|
          context "month: #{presence_of(month)}" do
            [7, nil, ""].each do |day|
              context "day: #{presence_of(day)}" do
                let(:year) { year }
                let(:month) { month }
                let(:day) { day }
                it_behaves_like "raises error"
              end
            end
          end
        end
      end
    end
  end
end

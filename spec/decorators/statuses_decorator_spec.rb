# frozen_string_literal: true

require "rails_helper"

RSpec.describe StatusesDecorator do
  describe "#tweeted_dates" do
    subject { described_class.new(collection).tweeted_dates }
    context "collection is a blank object" do
      let(:collection) { Status.none }
      it { is_expected.to eq [] }
    end
    context "collection is present" do
      let(:collection) { Status.all }
      describe "structure" do
        before do
          create(:status, tweeted_at: Time.zone.local(2019, 12, 2).to_i)
          create(:status, tweeted_at: Time.zone.local(2019, 12, 1).to_i)
          create(:status, tweeted_at: Time.zone.local(2018, 12, 1).to_i)
        end
        it "is grouped by year and month"  do
          is_expected.to eq(
            [
              {
                "2019": [
                  { "12": ["2", "1"] }
                ]
              },
              {
                "2018": [
                  { "12": ["1"] }
                ]
              }
            ]
          )
        end
      end

      describe "sort" do
        before do
          create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i)
          create(:status, tweeted_at: Time.zone.local(2019, 12, 1).to_i)
          create(:status, tweeted_at: Time.zone.local(2019, 12, 3).to_i)
        end
        it "is sorted by date in desc" do
          is_expected.to eq(
            [
              {
                "2019": [
                  { "12": ["31", "3", "1"] }
                ]
              }
            ]
          )
        end
      end

      describe "uniqueness" do
        before do
          create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i, tweet_id: 1)
          create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i, tweet_id: 2)
          create(:status, tweeted_at: Time.zone.local(2019, 12, 30).to_i, tweet_id: 3)
          create(:status, tweeted_at: Time.zone.local(2019, 12, 30).to_i, tweet_id: 4)
          create(:status, tweeted_at: Time.zone.local(2019, 11, 30).to_i, tweet_id: 5)
        end
        it "treats duplicating dates as one" do
          is_expected.to eq(
            [
              {
                "2019": [
                  { "12": ["31", "30"] },
                  { "11": ["30"] }
                ]
              }
            ]
          )
        end
      end
    end
  end
end

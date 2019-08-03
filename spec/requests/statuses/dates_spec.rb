# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Statuses::Dates", type: :request do
  describe "GET /statuses/dates" do
    subject { get statuses_dates_path }

    describe "no authentication required" do
      before do
        create(:status)
        subject
      end
      it_behaves_like "respond with status code", :ok
    end

    context "no status exists" do
      before { subject }
      it_behaves_like "respond with status code", :not_found
    end
    context "status exists" do
      describe "structure" do
        before do
          create(:status, tweeted_at: Time.zone.local(2019, 12, 2).to_i)
          create(:status, tweeted_at: Time.zone.local(2019, 12, 1).to_i)
          create(:status, tweeted_at: Time.zone.local(2018, 12, 1).to_i)
        end
        it "is grouped by year and month"  do
          subject
          expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
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
          subject
          expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
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
          subject
          expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
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

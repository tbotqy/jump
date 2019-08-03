# frozen_string_literal: true

require "rails_helper"

RSpec.describe "TweetedDates", type: :request do
  describe "GET /tweeted_dates" do
    subject { get tweeted_dates_path }

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
      describe "response is well structured" do
        before do
          create(:status, tweeted_at: Time.zone.local(2019, 12, 2).to_i)
          create(:status, tweeted_at: Time.zone.local(2019, 12, 1).to_i)
          create(:status, tweeted_at: Time.zone.local(2019, 11, 1).to_i)
          create(:status, tweeted_at: Time.zone.local(2018, 12, 1).to_i)
        end
        it "is grouped by year and month"  do
          subject
          expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
            [
              {
                "2019": [
                  { "12": ["2", "1"] },
                  { "11": ["1"] }
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
          [2019, 2018].each do |year|
            create(:status, tweeted_at: Time.zone.local(year, 12, 31).to_i)
            create(:status, tweeted_at: Time.zone.local(year, 12, 1).to_i)
            create(:status, tweeted_at: Time.zone.local(year, 12, 3).to_i)
          end
        end
        it "is sorted by date in desc" do
          subject
          expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
            [
              {
                "2019": [
                  { "12": ["31", "3", "1"] }
                ]
              },
              {
                "2018": [
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
        end
        it "treats duplicating dates as one" do
          subject
          expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
            [
              {
                "2019": [
                  { "12": ["31", "30"] }
                ]
              }
            ]
          )
        end
      end

      describe "only public statuses are included" do
        before do
          create(:status, private_flag: true,  tweeted_at: Time.zone.local(2019, 12, 31).to_i)
          create(:status, private_flag: false, tweeted_at: Time.zone.local(2019, 12, 30).to_i)
        end
        it do
          subject
          expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
            [
              {
                "2019": [
                  { "12": ["30"] }
                ]
              }
            ]
          )
        end
      end
    end
  end
end

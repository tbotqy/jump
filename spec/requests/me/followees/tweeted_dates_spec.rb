# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Me::Followees::TweetedDates", type: :request do
  describe "GET /me/followees/tweeted_dates" do
    subject { get me_followees_tweeted_dates_path, xhr: true }
    context "not authenticated" do
      let!(:user) { create(:user) }
      before { subject }
      it_behaves_like "respond with status code", :unauthorized
    end
    context "authenticated" do
      context "user has no followee" do
        let!(:user) { create(:user) }
        before do
          sign_in user
          subject
        end
        it_behaves_like "respond with status code", :not_found
      end
      context "user has followee" do
        context "user's followee has no status" do
          let!(:user) { create(:user) }
          before do
            sign_in user
            followee = create(:user)
            create(:followee, user: user, twitter_id: followee.twitter_id)
            subject
          end
          it_behaves_like "respond with status code", :not_found
        end
        context "user's followee has status" do
          let!(:user) { create(:user) }
          before { sign_in user }
          describe "response is well structured" do
            let!(:followee) do
              followee = create(:user)
              create(:followee, user: user, twitter_id: followee.twitter_id)
              followee
            end

            before do
              create(:status, tweeted_at: Time.zone.local(2019, 12, 2).to_i, user: followee)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 1).to_i, user: followee)
              create(:status, tweeted_at: Time.zone.local(2019, 11, 1).to_i, user: followee)
              create(:status, tweeted_at: Time.zone.local(2018, 12, 1).to_i, user: followee)
            end
            it "is grouped by year and month" do
              subject
              expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
                [
                  {
                    "2019": [
                      { "12": ["2", "1"] },
                      { "11": ["1"] },
                    ],
                  },
                  {
                    "2018": [
                      { "12": ["1"] },
                    ],
                  },
                ]
              )
            end
          end

          describe "sort" do
            let!(:followee) do
              followee = create(:user)
              create(:followee, user: user, twitter_id: followee.twitter_id)
              followee
            end

            before do
              [2019, 2018].each do |year|
                create(:status, tweeted_at: Time.zone.local(year, 12, 31).to_i, user: followee)
                create(:status, tweeted_at: Time.zone.local(year, 12, 1).to_i, user: followee)
                create(:status, tweeted_at: Time.zone.local(year, 12, 3).to_i, user: followee)
                create(:status, tweeted_at: Time.zone.local(year, 11, 30).to_i, user: followee)
                create(:status, tweeted_at: Time.zone.local(year, 11, 29).to_i, user: followee)
              end
            end
            it "is sorted by date in desc" do
              subject
              expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
                [
                  {
                    "2019": [
                      { "12": ["31", "3", "1"] },
                      { "11": ["30", "29"] },
                    ],
                  },
                  {
                    "2018": [
                      { "12": ["31", "3", "1"] },
                      { "11": ["30", "29"] },
                    ],
                  },
                ]
              )
            end
          end

          describe "uniqueness" do
            let!(:followee_1) do
              followee = create(:user)
              create(:followee, user: user, twitter_id: followee.twitter_id)
              followee
            end
            let!(:followee_2) do
              followee = create(:user)
              create(:followee, user: user, twitter_id: followee.twitter_id)
              followee
            end

            before do
              create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i, tweet_id: 1, user: followee_1)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i, tweet_id: 2, user: followee_1)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i, tweet_id: 3, user: followee_2)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i, tweet_id: 4, user: followee_2)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 30).to_i, tweet_id: 5, user: followee_1)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 30).to_i, tweet_id: 6, user: followee_1)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 30).to_i, tweet_id: 7, user: followee_2)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 30).to_i, tweet_id: 8, user: followee_2)
            end
            it "treats duplicating dates as one" do
              subject
              expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
                [
                  {
                    "2019": [
                      { "12": ["31", "30"] },
                    ],
                  },
                ]
              )
            end
          end

          describe "includes all the followees' tweeted dates" do
            let!(:followee_1) do
              followee = create(:user)
              create(:followee, user: user, twitter_id: followee.twitter_id)
              followee
            end
            let!(:followee_2) do
              followee = create(:user)
              create(:followee, user: user, twitter_id: followee.twitter_id)
              followee
            end

            before do
              create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i, user: followee_1)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 30).to_i, user: followee_2)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 29).to_i, user: followee_1)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 28).to_i, user: followee_2)
            end
            it do
              subject
              expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
                [
                  {
                    "2019": [
                      { "12": ["31", "30", "29", "28"] },
                    ],
                  },
                ]
              )
            end
          end

          describe "only includes user's followees' tweeted dates" do
            let!(:user_followee) do
              followee = create(:user)
              create(:followee, user: user, twitter_id: followee.twitter_id)
              followee
            end

            let!(:another_user_followee) do
              followee = create(:user)
              create(:followee, user: create(:user), twitter_id: followee.twitter_id)
              followee
            end

            before do
              create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i, user: another_user_followee)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 30).to_i, user: user_followee)
              create(:status, tweeted_at: Time.zone.local(2019, 12, 29).to_i, user: user)
            end
            it do
              subject
              expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
                [
                  {
                    "2019": [
                      { "12": ["30"] },
                    ],
                  },
                ]
              )
            end
          end

          describe "both public and private followee's tweeted dates are included" do
            let!(:followee) do
              followee = create(:user)
              create(:followee, user: user, twitter_id: followee.twitter_id)
              followee
            end

            before do
              create(:status, protected_flag: true, tweeted_at: Time.zone.local(2019, 12, 31).to_i, user: followee)
              create(:status, protected_flag: false, tweeted_at: Time.zone.local(2019, 12, 30).to_i, user: followee)
            end
            it do
              subject
              expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
                [
                  {
                    "2019": [
                      { "12": ["31", "30"] },
                    ],
                  },
                ]
              )
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::TweetedDates", type: :request do
  describe "GET /users/:user_id/tweeted_dates" do
    subject { get user_tweeted_dates_path(user_id: user_id), xhr: true }
    context "not authenticated" do
      context "the target resource is protected" do
        let!(:user)   { create(:user, protected_flag: true) }
        let(:user_id) { user.id }
        before do
          create(:status, user_id: user_id, protected_flag: true)
          subject
        end
        it_behaves_like "unauthenticated request"
      end
      context "the target resource is not protected" do
        let!(:user)   { create(:user, protected_flag: false) }
        let(:user_id) { user.id }
        before do
          create(:status, user_id: user_id, protected_flag: false)
          subject
        end
        it_behaves_like "respond with status code", :ok
      end
    end
    context "authenticated" do
      context "user with given id doesn't exist" do
        let!(:user)   { create(:user) }
        let(:user_id) { User.maximum(:id) + 1 }
        before do
          sign_in user
          subject
        end
        it_behaves_like "respond with status code", :not_found
      end
      context "user with given id exists" do
        context "given id is not authenticated user's" do
          context "the target user's resources are protected" do
            let!(:signed_in_user) { create(:user) }
            let!(:another_user)   { create(:user, protected_flag: true) }
            let!(:user_id)        { another_user.id }
            before do
              create(:status, user_id: user_id, protected_flag: true)
              sign_in signed_in_user
              subject
            end
            it_behaves_like "request for the other user's resource"
          end
          context "the target user's resources are not protected" do
            let!(:signed_in_user) { create(:user) }
            let!(:another_user)   { create(:user, protected_flag: false) }
            let!(:user_id)        { another_user.id }
            before do
              create(:status, user_id: user_id, protected_flag: false)
              sign_in signed_in_user
              subject
            end
            it_behaves_like "respond with status code",  :ok
          end
        end
        context "given id is authenticated user's" do
          context "user has no status" do
            let!(:user)    { create(:user) }
            let!(:user_id) { user.id }
            before do
              sign_in user
              subject
            end
            it_behaves_like "respond with status code", :not_found
          end
          context "user has status" do
            let!(:user)    { create(:user) }
            let!(:user_id) { user.id }
            before { sign_in user }

            describe "response is well structured" do
              before do
                create(:status, tweeted_at: Time.zone.local(2019, 12, 2).to_i, user: user)
                create(:status, tweeted_at: Time.zone.local(2019, 12, 1).to_i, user: user)
                create(:status, tweeted_at: Time.zone.local(2019, 11, 1).to_i, user: user)
                create(:status, tweeted_at: Time.zone.local(2018, 12, 1).to_i, user: user)
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
                  create(:status, tweeted_at: Time.zone.local(year, 12, 31).to_i, user: user)
                  create(:status, tweeted_at: Time.zone.local(year, 12, 1).to_i,  user: user)
                  create(:status, tweeted_at: Time.zone.local(year, 12, 3).to_i,  user: user)
                  create(:status, tweeted_at: Time.zone.local(year, 11, 30).to_i, user: user)
                  create(:status, tweeted_at: Time.zone.local(year, 11, 29).to_i, user: user)
                end
              end
              it "is sorted by date in desc" do
                subject
                expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
                  [
                    {
                      "2019": [
                        { "12": ["31", "3", "1"] },
                        { "11": ["30", "29"] }
                      ]
                    },
                    {
                      "2018": [
                        { "12": ["31", "3", "1"] },
                        { "11": ["30", "29"] }
                      ]
                    }
                  ]
                )
              end
            end

            describe "uniqueness" do
              before do
                create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i, tweet_id: 1, user: user)
                create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i, tweet_id: 2, user: user)
                create(:status, tweeted_at: Time.zone.local(2019, 12, 30).to_i, tweet_id: 3, user: user)
                create(:status, tweeted_at: Time.zone.local(2019, 12, 30).to_i, tweet_id: 4, user: user)
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

            describe "user scope is applied"  do
              let!(:another_user) { create(:user) }
              before do
                create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i, tweet_id: 1, user: user)
                create(:status, tweeted_at: Time.zone.local(2019, 12, 31).to_i, tweet_id: 2, user: another_user)
                create(:status, tweeted_at: Time.zone.local(2019, 12, 30).to_i, tweet_id: 3, user: another_user)
                create(:status, tweeted_at: Time.zone.local(2019, 11, 30).to_i, tweet_id: 4, user: user)
              end
              it "only includes specified user's tweeted dates" do
                subject
                expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq(
                  [
                    {
                      "2019": [
                        { "12": ["31"] },
                        { "11": ["30"] }
                      ]
                    }
                  ]
                )
              end
            end

            describe "both public and private statuses are included" do
              before do
                create(:status, protected_flag: true,  tweeted_at: Time.zone.local(2019, 12, 31).to_i, user: user)
                create(:status, protected_flag: false, tweeted_at: Time.zone.local(2019, 12, 30).to_i, user: user)
              end
              it do
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
          end
        end
      end
    end
  end
end

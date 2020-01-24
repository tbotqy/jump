# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Me::Users", type: :request do
  describe "GET /me" do
    subject { get me_path, xhr: true }

    context "not authenticated" do
      let!(:user) { create(:user) }
      before { subject }
      it_behaves_like "respond with status code", :unauthorized
    end
    context "authenticated" do
      describe "status code" do
        before do
          sign_in create(:user)
          subject
        end
        it_behaves_like "respond with status code", :ok
      end
      describe "response body" do
        describe "required attributes" do
          let(:name)           { "name" }
          let(:screen_name)    { "screen_name" }
          let(:avatar_url)     { "avatar_url" }
          let(:protected_flag) { true }
          let(:status_count)   { 100 }
          let(:followee_count) { 200 }
          let(:user) do
            create(:user,
              :with_statuses_and_followees,
              name:           name,
              screen_name:    screen_name,
              avatar_url:     avatar_url,
              protected_flag: protected_flag,
              status_count:   status_count,
              followee_count: followee_count
            )
          end

          before do
            sign_in user
            subject
          end

          it do
            expect(response.parsed_body.symbolize_keys).to include(
              id:            user.id,
              name:          name,
              screenName:    screen_name,
              avatarUrl:     avatar_url,
              protectedFlag: protected_flag,
              statusCount:   status_count.to_s(:delimited),
              followeeCount: followee_count.to_s(:delimited)
            )
          end
        end
        describe "nullable attributes" do
          describe "#profile_banner_url" do
            before do
              sign_in user
              subject
            end
            context "null" do
              let(:user) { create(:user, profile_banner_url: nil) }
              it do
                expect(response.parsed_body.symbolize_keys).to include(profileBannerUrl: nil)
              end
            end
            context "present" do
              let(:profile_banner_url) { "https://foo/bar" }
              let(:user) { create(:user, profile_banner_url: profile_banner_url) }
              it do
                expect(response.parsed_body.symbolize_keys).to include(profileBannerUrl: profile_banner_url)
              end
            end
          end
          describe "#statuses_updated_at" do
            before do
              sign_in user
              subject
            end
            context "null" do
              let(:user) { create(:user, statuses_updated_at: nil) }
              it do
                expect(response.parsed_body.symbolize_keys).to include(statusesUpdatedAt: nil)
              end
            end
            context "present" do
              let(:at) { 1 }
              let(:user) { create(:user, statuses_updated_at: at) }
              it do
                expect(response.parsed_body.symbolize_keys).to include(statusesUpdatedAt: Time.zone.at(at).iso8601)
              end
            end
          end
          describe "#followees_updated_at" do
            context "null" do
              let(:user) { create(:user) } # user with no followee
              before do
                sign_in user
                subject
              end
              it do
                expect(response.parsed_body.symbolize_keys).to include(followeesUpdatedAt: nil)
              end
            end
            context "present" do
              let(:user) { create(:user) }
              before do
                create_list(:followee, 2, user: user)
                create_list(:followee, 2) # the another user's followees
                sign_in user
                subject
              end
              it do
                expect(response.parsed_body.symbolize_keys).to include(followeesUpdatedAt: user.followees.maximum(:created_at).iso8601)
              end
            end
          end
        end
      end
    end
  end
end

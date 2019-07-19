# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::TweetImportProgresses", type: :request do
  describe "GET /users/:user_id/tweet_import_progress" do
    subject { get user_tweet_import_progress_path(user_id: user_id) }

    context "not authenticated" do
      let!(:user)    { create(:user) }
      let!(:user_id) { user.id }
      before { subject }
      it_behaves_like "unauthenticated request"
    end
    context "authenticated" do
      context "user not found" do
        let!(:user)    { create(:user) }
        let!(:user_id) { User.maximum(:id) + 1 }
        before do
          sign_in user
          subject
        end
        it_behaves_like "respond with status code", :not_found
      end
      context "user found" do
        context "unauthorized to operate on the found user" do
          let!(:signed_in_user) { create(:user) }
          let!(:another_user)   { create(:user) }
          let!(:user_id)        { another_user.id }
          before do
            sign_in signed_in_user
            subject
          end
          it_behaves_like "request for the other user's resource"
        end
        context "authorized to operate on the found user" do
          context "user has no import progress record" do
            let!(:user)    { create(:user) }
            let!(:user_id) { user.id }
            before do
              sign_in user
              subject
            end
            it_behaves_like "respond with status code", :not_found
          end
          context "user has some import progress records" do
            context "no status has been imported yet" do
              let!(:user)                  { create(:user) }
              let!(:user_id)               { user.id }
              let!(:tweet_import_progress) { create(:tweet_import_progress, user: user, count: 0, percentage_denominator: percentage_denominator) }

              let(:assumed_imported_status_count) { 0 }
              let(:percentage_denominator)        { 200 }
              before do
                sign_in user
                subject
              end
              it_behaves_like "respond with status code", :ok
              it do
                expect(response.parsed_body.deep_symbolize_keys).to include(
                  percentage:  0,
                  last_status: {},
                  user:        user.as_json
                )
              end
            end
            context "some statuses have been imported" do
              let!(:user)                  { create(:user) }
              let!(:user_id)               { user.id }
              let!(:statuses)              { create_list(:status, assumed_imported_status_count, user: user) }
              let!(:entities)              { statuses.each { |status| create(:entity, status: status) } }
              let!(:tweet_import_progress) { create(:tweet_import_progress, user: user, count: assumed_imported_status_count, percentage_denominator: percentage_denominator) }

              let(:assumed_imported_status_count) { 3 }
              let(:percentage_denominator)        { 200 }
              let(:expected_percentage)           { 1 } # (3/200.to_f).floor
              before do
                sign_in user
                subject
              end
              it_behaves_like "respond with status code", :ok
              it do
                expect(response.parsed_body.deep_symbolize_keys).to include(
                  percentage:  expected_percentage,
                  last_status: statuses.last.as_json,
                  user:        user.as_json
                )
              end
            end
          end
        end
      end
    end
  end
end

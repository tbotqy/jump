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
              let!(:tweet_import_progress) { create(:tweet_import_progress, user: user) }

              let(:assumed_imported_status_count) { 0 }
              before do
                sign_in user
                subject
              end
              it_behaves_like "respond with status code", :ok
              it do
                expect(response.parsed_body.deep_symbolize_keys).to include(
                  percentage:    0,
                  finished:      false,
                  last_tweet_id: nil
                )
              end
            end
            context "statuses are being imported" do
              let!(:user)                  { create(:user) }
              let!(:user_id)               { user.id }
              let!(:statuses)              { create_list(:status, assumed_imported_status_count, user: user) }
              let!(:entities)              { statuses.each { |status| create(:entity, status: status) } }
              let!(:tweet_import_progress) { create(:tweet_import_progress, user: user) }

              let(:assumed_imported_status_count) { 33 }
              let(:expected_percentage)           { 1 } # (33/3200(=Settings.twitter.traceable_tweet_count_limit).to_f).floor
              let(:last_tweet_id) { "12345" }
              before do
                sign_in user
                tweet_import_progress.current_count.reset(assumed_imported_status_count)
                tweet_import_progress.last_tweet_id = last_tweet_id
                subject
              end
              it_behaves_like "respond with status code", :ok
              it do
                expect(response.parsed_body.deep_symbolize_keys).to include(
                  percentage:    expected_percentage,
                  finished:      false,
                  last_tweet_id: last_tweet_id
                )
              end
            end
            context "status import has been finished" do
              let!(:user)                  { create(:user) }
              let!(:user_id)               { user.id }
              let!(:statuses)              { create_list(:status, total_imported_count, user: user) }
              let!(:entities)              { statuses.each { |status| create(:entity, status: status) } }
              let!(:tweet_import_progress) { create(:tweet_import_progress, finished: true, user: user) }

              let(:total_imported_count) { 33 }
              let(:expected_percentage)  { 1 } # (33/3200(=Settings.twitter.traceable_tweet_count_limit).to_f).floor
              let(:last_tweet_id) { "12345" }
              before do
                sign_in user
                tweet_import_progress.current_count.reset(total_imported_count)
                tweet_import_progress.last_tweet_id = last_tweet_id
                subject
              end
              it_behaves_like "respond with status code", :ok
              it do
                expect(response.parsed_body.deep_symbolize_keys).to include(
                  percentage:    expected_percentage,
                  finished:      true,
                  last_tweet_id: last_tweet_id
                )
              end
            end
          end
        end
      end
    end
  end
end

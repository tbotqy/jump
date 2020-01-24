# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Me::TweetImportProgresses", type: :request do
  describe "GET /me/tweet_import_progress" do
    subject { get me_tweet_import_progress_path, xhr: true }
    context "not authenticated" do
      before do
        create(:user)
        subject
      end
      it_behaves_like "unauthenticated request"
    end
    context "authenticated" do
      context "user has no import progress record" do
        before do
          sign_in create(:user)
          subject
        end
        it_behaves_like "respond with status code", :not_found
      end
      context "user has some import progress records" do
        context "no status has been imported yet" do
          let!(:user)                  { create(:user) }
          let!(:tweet_import_progress) { create(:tweet_import_progress, user: user) }
          before do
            sign_in user
            subject
          end
          it_behaves_like "respond with status code", :ok
          it do
            expect(response.parsed_body.deep_symbolize_keys).to include(
              percentage:  0,
              finished:    false,
              lastTweetId: nil
            )
          end
        end
        context "statuses are being imported" do
          let!(:user)                  { create(:user) }
          let!(:statuses)              { create_list(:status, assumed_imported_status_count, user: user) }
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
              percentage:  expected_percentage,
              finished:    false,
              lastTweetId: last_tweet_id
            )
          end
        end
        context "status import has been finished" do
          let!(:user)                  { create(:user) }
          let!(:statuses)              { create_list(:status, total_imported_count, user: user) }
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
              percentage:  expected_percentage,
              finished:    true,
              lastTweetId: last_tweet_id
            )
          end
        end
      end
    end
  end
end

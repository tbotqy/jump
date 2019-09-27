# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Statuses", type: :request do
  describe "PUT /users/:id/statuses" do
    subject { put user_statuses_path(user_id: user_id), xhr: true }

    shared_examples "doesn't enqueue the job" do
      it { expect(MakeAdditionalTweetImportJob).not_to have_been_enqueued }
    end

    context "user has not been authenticated" do
      let!(:user_id) { create(:user).id }
      before { subject }
      it_behaves_like "doesn't enqueue the job"
      it_behaves_like "respond with status code", :unauthorized
    end
    context "user has been authenticated" do
      context "user with given id doesn't exist" do
        let!(:user)   { create(:user) }
        let(:user_id) { User.maximum(:id) + 1 }
        before do
          sign_in user
          subject
        end
        it_behaves_like "doesn't enqueue the job"
        it_behaves_like "respond with status code", :not_found
      end
      context "user with given id exists" do
        context "given id isn't an authenticated user's id" do
          let!(:user)    { create(:user) }
          let!(:user_id) { create(:user).id }
          before do
            sign_in user
            subject
          end
          it_behaves_like "doesn't enqueue the job"
          it_behaves_like "request for the other user's resource"
        end
        context "given id is an authenticated user's id" do
          let!(:user)   { create(:user) }
          let(:user_id) { user.id }
          context "user has a working job" do
            before do
              create(:tweet_import_lock, user: user)
              sign_in user
              subject
            end
            it_behaves_like "doesn't enqueue the job"
            it_behaves_like "respond with status code", :too_many_requests
          end
          context "user has no working job" do
            context "fails to kick the job" do
              before do
                allow(MakeAdditionalTweetImportJob).to receive(:perform_later).with(user_id: user_id.to_s).and_raise(RuntimeError)
                sign_in user
                subject
              end
              it_behaves_like "doesn't enqueue the job"
              it_behaves_like "respond with status code", :internal_server_error
            end
            context "succeeds to kick the job" do
              before do
                sign_in user
                subject
              end
              it "enqueues the job " do
                expect(MakeAdditionalTweetImportJob).to have_been_enqueued.with(user_id: user_id.to_s).exactly(:once)
              end
              it_behaves_like "respond with status code", :accepted
            end
          end
        end
      end
    end
  end
end

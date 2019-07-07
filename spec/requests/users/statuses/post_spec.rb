# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Statuses", type: :request do
  describe "POST /users/:id/statuses" do
    subject { post user_statuses_path(user_id: user_id) }
    shared_examples "doesn't enqueue the job" do
      it { expect(ImportTweetsJob).not_to have_been_enqueued }
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
          context "failed to kick the job" do
            before do
              allow(ImportTweetsJob).to receive(:perform_later).and_raise(RuntimeError)
              sign_in user
              subject
            end
            it_behaves_like "doesn't enqueue the job"
            it_behaves_like "respond with status code", :internal_server_error
          end
          context "succeeded to kick the job" do
            before do
              sign_in user
              subject
            end
            it "enqueues the job " do
              expect(ImportTweetsJob).to have_been_enqueued.exactly(:once)
            end
            it_behaves_like "respond with status code", :accepted
          end
        end
      end
    end
  end
end

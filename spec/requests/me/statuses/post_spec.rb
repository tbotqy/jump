# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Me::Statuses", type: :request do
  describe "POST /me/statuses" do
    subject { post me_statuses_path, xhr: true }
    shared_examples "doesn't enqueue the job" do
      it { expect(MakeInitialTweetImportJob).not_to have_been_enqueued }
    end

    context "not authenticated" do
      let!(:user) { create(:user) }
      before { subject }
      it_behaves_like "doesn't enqueue the job"
      it_behaves_like "respond with status code", :unauthorized
    end
    context "authenticated" do
      let!(:user) { create(:user) }
      context "user has a working job" do
        before do
          create(:tweet_import_progress, user: user)
          sign_in user
          subject
        end
        it_behaves_like "doesn't enqueue the job"
        it_behaves_like "respond with status code", :accepted
      end
      context "user has no working job" do
        context "fails to kick the job" do
          before do
            allow(MakeInitialTweetImportJob).to receive(:perform_later).with(user_id: user.id).and_raise(RuntimeError)
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
            expect(MakeInitialTweetImportJob).to have_been_enqueued.with(user_id: user.id).exactly(:once)
          end
          it_behaves_like "respond with status code", :accepted
        end
      end
    end
  end
end

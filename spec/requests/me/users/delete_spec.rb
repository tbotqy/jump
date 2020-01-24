# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Me::Users", type: :request do
  describe "DELETE /me" do
    subject { delete me_path, xhr: true }

    shared_examples "doesn't enqueue the job" do
      it { expect(DestroyUserJob).not_to have_been_enqueued }
    end

    shared_examples "doesn't make the user signed out" do
      it { expect(controller.current_user).to eq user }
    end

    context "not authenticated" do
      let!(:user) { create(:user) }
      before { subject }
      it_behaves_like "doesn't enqueue the job"
      it_behaves_like "respond with status code", :unauthorized
    end
    context "authenticated" do
      let!(:user) { create(:user) }
      context "failed to kick the job" do
        before do
          allow(DestroyUserJob).to receive(:perform_later).and_raise(RuntimeError)
          sign_in user
          subject
        end
        it_behaves_like "doesn't enqueue the job"
        it_behaves_like "doesn't make the user signed out"
        it_behaves_like "respond with status code", :internal_server_error
      end
      context "succeeded to kick the job" do
        before do
          sign_in user
          subject
        end
        it "enqueues the job " do
          expect(DestroyUserJob).to have_been_enqueued.exactly(:once)
        end
        it "makes the user signed out" do
          expect(controller.current_user).to eq nil
        end
        it_behaves_like "respond with status code", :accepted
      end
    end
  end
end

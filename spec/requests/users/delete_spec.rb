# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "DELETE /users/:id" do
    subject { delete user_path(id: id), xhr: true }

    shared_examples "doesn't enqueue the job" do
      it { expect(DestroyUserJob).not_to have_been_enqueued }
    end

    shared_examples "doesn't make the user signed out" do
      it { expect(controller.current_user).to eq user }
    end

    context "user has not been authenticated" do
      let(:user) { create(:user) }
      let(:id)   { user.id }
      before { subject }
      it_behaves_like "doesn't enqueue the job"
      it_behaves_like "respond with status code", :unauthorized
    end
    context "user has been authenticated" do
      context "user with given id doesn't exist" do
        let!(:user) { create(:user) }
        let(:id)    { User.maximum(:id) + 1 }
        before do
          sign_in user
          subject
        end
        it_behaves_like "doesn't enqueue the job"
        it_behaves_like "doesn't make the user signed out"
        it_behaves_like "respond with status code", :not_found
      end
      context "user with given id exists" do
        context "given id isn't an authenticated user's id" do
          let(:user) { create(:user) }
          let(:id)   { create(:user).id }
          before do
            sign_in user
            subject
          end
          it_behaves_like "doesn't enqueue the job"
          it_behaves_like "doesn't make the user signed out"
          it_behaves_like "request for the other user's resource"
        end
        context "given id is an authenticated user's id" do
          let(:user) { create(:user) }
          let!(:id)  { user.id }
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
  end
end

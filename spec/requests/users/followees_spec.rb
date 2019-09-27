# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Followees", type: :request do
  describe "POST /users/:id/followees" do
    subject { post user_followees_path(user_id: user_id), xhr: true }

    shared_examples "doesn't call the service class" do
      it { expect(RenewUserFolloweesService).not_to have_received(:call!).with(anything) }
    end

    def spy_service_class_call
      allow(RenewUserFolloweesService).to receive(:call!).with(user_id: user_id.to_s).once.and_return(nil)
    end

    context "user has not been authenticated" do
      let!(:user_id) { create(:user).id }
      before do
        spy_service_class_call
        subject
      end
      it_behaves_like "doesn't call the service class"
      it_behaves_like "respond with status code", :unauthorized
    end
    context "user has been authenticated" do
      context "user with given id doesn't exist" do
        let!(:user)   { create(:user) }
        let(:user_id) { User.maximum(:id) + 1 }
        before do
          spy_service_class_call
          sign_in user
          subject
        end
        it_behaves_like "doesn't call the service class"
        it_behaves_like "respond with status code", :not_found
      end
      context "user with given id exists" do
        context "given id isn't an authenticated user's id" do
          let!(:user)    { create(:user) }
          let!(:user_id) { create(:user).id }
          before do
            spy_service_class_call
            sign_in user
            subject
          end
          it_behaves_like "doesn't call the service class"
          it_behaves_like "request for the other user's resource"
        end
        context "given id is an authenticated user's id" do
          let!(:user)   { create(:user) }
          let(:user_id) { user.id }
          context "failed to call the service class" do
            before do
              allow(RenewUserFolloweesService).to receive(:call!).with(user_id: user_id.to_s).once.and_raise(RuntimeError)
              sign_in user
              subject
            end
            it_behaves_like "respond with status code", :internal_server_error
          end
          context "succeeded to call the service class" do
            let(:user_followees_count) { 10 }
            before do
              create_list(:followee, user_followees_count, user: user)
              spy_service_class_call
              sign_in user
              subject
            end
            it "calls the service class" do
              expect(RenewUserFolloweesService).to have_received(:call!).with(user_id: user_id.to_s).once
            end
            it_behaves_like "respond with status code", :ok
            it "returns an expected content" do
              expect(response.parsed_body.symbolize_keys).to include(total_followees_count: user_followees_count)
            end
          end
        end
      end
    end
  end
end

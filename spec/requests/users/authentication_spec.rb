# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User authentication", type: :request do
  describe "GET /users/auth/twitter" do
    after :each do
      # reset the configured mock at the end of each examples
      OmniAuth.config.mock_auth[:twitter] = nil
    end

    before { get user_twitter_omniauth_authorize_path }
    describe "lead the user to authorize our app and finally get back to our callback action" do
      it { expect(response).to have_http_status(302) }
      it { expect(response.location).to include("/users/auth/twitter/callback") }
    end

    describe "GET /users/auth/twitter/callback" do
      context "obtained auth hash is invalid" do
        before do
          OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
          get user_twitter_omniauth_callback_path
        end
        it { expect(response).to redirect_to sign_out_path }
      end

      context "obtained auth hash is valid" do
        context "failed to interact with DB" do
          before do
            OmniAuth.config.mock_auth[:twitter] = auth_hash_mock.merge(uid: nil)
            get user_twitter_omniauth_callback_path
          end
          it { expect(response).to have_http_status(500) }
        end
        context "succeeded to interact with DB" do
          subject { get user_twitter_omniauth_callback_path }

          describe "registration of new user" do
            let!(:existing_user) { create(:user) }
            let!(:brand_new_uid) { existing_user.uid + "123" }
            before do
              # include brand-new uid in auth_hash_mock
              OmniAuth.config.mock_auth[:twitter] = auth_hash_mock.merge(uid: brand_new_uid)
            end

            it { expect { subject }.to change { User.count }.by(1) }
            it "registers a new user with given uid" do
              expect { subject }.to change { User.exists?(uid: brand_new_uid) }.from(false).to(true)
            end
          end
          describe "update of existing user" do
            let!(:name_before_update) { "suzuki" }
            let!(:name_in_auth) { "suzuki++" }
            let!(:existing_user) { create(:user, name: name_before_update) }
            before do
              existing_uid = existing_user.uid
              OmniAuth.config.mock_auth[:twitter] = auth_hash_mock.merge(uid: existing_uid, extra: { raw_info: { name: name_in_auth } })
            end

            it { expect { subject }.not_to change { User.count } }
            it "updates the user with given auth" do
              expect { subject }.to change { existing_user.reload.name }.from(name_before_update).to(name_in_auth)
            end
          end

          describe "sign in" do
            let!(:user) { create(:user) }
            before do
              OmniAuth.config.mock_auth[:twitter] = auth_hash_mock.merge(uid: user.uid)
              get user_twitter_omniauth_callback_path
            end
            it { expect(controller.current_user).to eq user }
          end

          describe "redirection and its response header" do
            shared_examples "includes user_id as a value of Set-Cookie attr in response header" do
              it { expect(response.header.fetch("Set-Cookie")).to include("user_id=#{authenticating_user.id}") }
            end

            before do
              OmniAuth.config.mock_auth[:twitter] = auth_hash_mock.merge(uid: authenticating_user.uid)
              get user_twitter_omniauth_callback_path
            end

            context "the user has never imported its own tweets yet" do
              let!(:authenticating_user) { create(:user) }
              it { expect(response).to redirect_to status_import_url }
              it_behaves_like "includes user_id as a value of Set-Cookie attr in response header"
            end
            context "the user has already imported its own tweets" do
              let!(:authenticating_user) do
                user = create(:user)
                create_list(:status, 3, user: user)
                user
              end
              it { expect(response).to redirect_to user_timeline_url }
              it_behaves_like "includes user_id as a value of Set-Cookie attr in response header"
            end
          end
        end
      end
    end
  end

  describe "GET /sign_out" do
    let!(:user) { create(:user) }
    context "user is signed in" do
      before do
        sign_in user
        get sign_out_path
      end
      it "gets the user signed out" do
        expect(controller.current_user).to eq nil
      end
      it { expect(response).to redirect_to service_top_url }
    end
    context "without any signing in" do
      before { get sign_out_path }
      it { expect(response).to redirect_to service_top_url }
    end
  end
end

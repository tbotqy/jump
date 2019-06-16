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
            let!(:brand_new_uid) { existing_user.uid + "new" }
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

          describe "redirection after registration/update" do
            before do
              OmniAuth.config.mock_auth[:twitter] = auth_hash_mock.merge(uid: authenticating_user.uid)
              get user_twitter_omniauth_callback_path
            end

            context "the user has never imported own tweets" do
              let!(:authenticating_user) { create(:user, finished_initial_import: false) }
              it { expect(response).to redirect_to status_import_path }
            end
            context "the user has already imported own tweets" do
              let!(:authenticating_user) { create(:user, finished_initial_import: true) }
              it { expect(response).to redirect_to user_timeline_path }
            end
          end
        end
      end
    end
  end
end

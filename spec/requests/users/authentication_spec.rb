# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User authentication", type: :request do
  describe "POST /users/auth/twitter" do
    describe "lead the user to authorize our app and finally get back to our callback action" do
      before { post user_twitter_omniauth_authorize_path }
      it { expect(response).to have_http_status(302) }
      it { expect(response.location).to include("/users/auth/twitter/callback") }
    end
  end

  describe "GET /users/auth/twitter" do
    describe "GET method is not allowed" do
      before { get user_twitter_omniauth_authorize_path }
      it { expect(response).to have_http_status(404) }
    end
  end

  describe "GET /users/auth/twitter/callback" do
    after :each do
      # reset the configured mock at the end of each examples
      OmniAuth.config.mock_auth[:twitter] = nil
    end
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

        describe "sync protection state of user statuses" do
          subject { -> { get user_twitter_omniauth_callback_path } }
          context "user has some statuses imported" do
            context "from unprotected to protected" do
              let(:before_protected_flag) { false }

              let!(:user) { create(:user, protected_flag: before_protected_flag) }
              let!(:user_statuses) do
                before_updated_at = Time.current - 1.day
                create_list(:status, 3, user: user, protected_flag: before_protected_flag, created_at: before_updated_at, updated_at: before_updated_at)
              end

              before do
                travel_to(Time.current)
                OmniAuth.config.mock_auth[:twitter] = auth_hash_mock.merge(uid: user.uid, extra: { raw_info: { protected: !before_protected_flag } })
                sign_in user
              end
              after { travel_back }

              it "makes all the user's statuses protected" do
                is_expected.to change { Status.where(user: user).pluck(:protected_flag).uniq.first }.to(!before_protected_flag)
              end
              it "updates timestamp of all the user's statuses" do
                is_expected.to change { Status.where(user: user).pluck(:updated_at).uniq.first }.to(Time.current)
              end
            end
          end
        end

        describe "redirection and its response header" do
          shared_examples "includes user_id as a value of Set-Cookie attr in response header, with target domain specified" do
            it { expect(response.header.fetch("Set-Cookie")).to include("user_id=#{authenticating_user.id}; domain=.example.com;") }
          end

          before do
            OmniAuth.config.mock_auth[:twitter] = auth_hash_mock.merge(uid: authenticating_user.uid)
            get user_twitter_omniauth_callback_path
          end

          context "the user has never imported its own tweets yet" do
            let!(:authenticating_user) { create(:user) }
            it { expect(response).to redirect_to status_import_url }
            it_behaves_like "includes user_id as a value of Set-Cookie attr in response header, with target domain specified"
          end
          context "the user has already imported its own tweets" do
            let!(:authenticating_user) do
              user = create(:user)
              create_list(:status, 3, user: user)
              user
            end
            it { expect(response).to redirect_to user_timeline_url }
            it_behaves_like "includes user_id as a value of Set-Cookie attr in response header, with target domain specified"
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

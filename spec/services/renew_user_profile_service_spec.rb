# frozen_string_literal: true

require "rails_helper"

describe RenewUserProfileService do
  include TwitterUserMock

  subject { -> { described_class.call!(user_id: user_id) } }
  describe ".call!" do
    context "fails to identify the user" do
      let!(:user)   { create(:user) }
      let(:user_id) { User.maximum(:id) + 1 }
      it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
    end
    context "succeeds to identify the user" do
      let(:user_twitter_client) { instance_double("TwitterClient") }
      before { allow_any_instance_of(described_class).to receive(:user_twitter_client).and_return(user_twitter_client) }

      context "fails to fetch data" do
        let!(:user_id) { create(:user).id }
        before { allow(user_twitter_client).to receive(:twitter_user).and_raise(Twitter::Error) }
        it { is_expected.to raise_error(Twitter::Error) }
      end
      context "succeeds to fetch data" do
        context "fails to update the user" do
          let!(:user_id) { create(:user).id }
          let(:incomplete_api_response) { twitter_user_mock(name: "") }
          before { allow(user_twitter_client).to receive(:twitter_user).and_return(incomplete_api_response) }
          it { is_expected.to raise_error(ActiveRecord::RecordInvalid) }

          context "succeeds to update the user" do
            let(:initial_name)           { "initial user name" }
            let(:initial_screen_name)    { "initial user screen_name" }
            let(:initial_protected_flag) { false }
            let(:initial_avatar_url)     { "https://old.com/old.jpg" }
            let!(:user_id) do
              user = create(:user,
                name:           initial_name,
                screen_name:    initial_screen_name,
                avatar_url:     initial_avatar_url,
                protected_flag: initial_protected_flag
              )
              user.id
            end
            let(:api_response) do
              twitter_user_mock(
                name:                    "new name",
                screen_name:             "new screen_name",
                profile_image_url_https: "https://new.com/new.jpg",
                protected?:              true
              )
            end
            before { allow(user_twitter_client).to receive(:twitter_user).and_return(api_response) }
            describe "updates the user with API response" do
              it { is_expected.to change { User.find(user_id).name           }.from(initial_name)          .to(api_response.name) }
              it { is_expected.to change { User.find(user_id).screen_name    }.from(initial_screen_name)   .to(api_response.screen_name) }
              it { is_expected.to change { User.find(user_id).protected_flag }.from(initial_protected_flag).to(api_response.protected?) }
              it { is_expected.to change { User.find(user_id).avatar_url     }.from(initial_avatar_url)    .to(api_response.profile_image_url_https.to_s) }
            end
            it { is_expected.not_to raise_error }
          end
        end
      end
    end
  end
end

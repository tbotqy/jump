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
        end

        context "succeeds to update the user" do
          let(:initial_name)           { "initial user name" }
          let(:initial_screen_name)    { "initial user screen_name" }
          let(:initial_protected_flag) { false }
          let(:initial_avatar_url)     { "https://old.com/old.jpg" }
          let(:initial_profile_banner_url) { "https://old.com/old-banner/ipad_retina" }
          let!(:user) do
            create(:user,
              name:           initial_name,
              screen_name:    initial_screen_name,
              avatar_url:     initial_avatar_url,
              profile_banner_url: initial_profile_banner_url,
              protected_flag: initial_protected_flag
            )
          end
          let!(:user_statuses) { create_list(:status, 3, user: user, protected_flag: initial_protected_flag, updated_at: Time.zone.at(1) - 1.day) }
          let(:user_id) { user.id }

          let(:profile_banner_url_in_api_response) { "https://new.com/new-banner/ipad_retina" }
          let(:api_response) do
            twitter_user_mock(
              name:                    "new name",
              screen_name:             "new screen_name",
              profile_image_url_https: "https://new.com/new.jpg",
              protected?:              !initial_protected_flag
            ) # profile_banner_url_https is mocked in before's block
          end
          before do
            travel_to(Time.current)
            allow(api_response).to receive(:profile_banner_url_https).with(:ipad_retina).and_return(profile_banner_url_in_api_response)
            allow(user_twitter_client).to receive(:twitter_user).and_return(api_response)
          end
          after { travel_back }

          context "fails to update the user's statuses' protected flag" do
            before do
              allow_any_instance_of(ActiveRecord::Associations::CollectionProxy).to receive(:update_all)
                .with(protected_flag: api_response.protected?, updated_at: Time.current)
                .and_raise(ActiveRecord::RecordInvalid)
            end
            it "doesn't update the user" do
              expect { subject.call rescue nil }.not_to change { User.find(user_id).attributes }
            end
            it { is_expected.to raise_error(ActiveRecord::RecordInvalid) }
          end
          context "succeeds to update the user's statuses' protected flag" do
            describe "updates the user with API response" do
              it { is_expected.to change { User.find(user_id).name           }.from(initial_name)          .to(api_response.name) }
              it { is_expected.to change { User.find(user_id).screen_name    }.from(initial_screen_name)   .to(api_response.screen_name) }
              it { is_expected.to change { User.find(user_id).protected_flag }.from(initial_protected_flag).to(api_response.protected?) }
              it { is_expected.to change { User.find(user_id).avatar_url     }.from(initial_avatar_url)    .to(api_response.profile_image_url_https.to_s) }
              describe "#profile_banner_url, that is nullable" do
                context "present" do
                  let(:profile_banner_url_in_api_response) { "https://new.com/new-banner/ipad_retina" }
                  it { is_expected.to change { User.find(user_id).profile_banner_url }.from(initial_profile_banner_url).to(profile_banner_url_in_api_response) }
                end
                context "blank" do
                  let(:profile_banner_url_in_api_response) { nil }
                  it { is_expected.to change { User.find(user_id).profile_banner_url }.from(initial_profile_banner_url).to(profile_banner_url_in_api_response) }
                end
              end
            end
            it "updates the user's statuses' protected_flag with the one in API response" do
              is_expected.to change { User.find(user_id).statuses.pluck(:protected_flag).uniq.first }.from(initial_protected_flag).to(api_response.protected?)
            end
            it "updates the user's statuses' updated_at" do
              is_expected.to change { User.find(user_id).statuses.pluck(:updated_at).uniq.first }.to(Time.current)
            end
            it { is_expected.not_to raise_error }
          end
        end
      end
    end
  end
end

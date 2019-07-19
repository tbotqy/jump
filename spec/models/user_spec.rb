# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:statuses).dependent(:destroy) }
    it { should have_many(:followees).dependent(:delete_all) }
    it { should have_one(:tweet_import_progress).dependent(:destroy) }
    it { should have_many(:profile_update_fail_logs).dependent(:delete_all) }
  end

  describe "validations" do
    describe "#uid" do
      before { create(:user) } # pre-register to validate uniqueness
      it { should validate_presence_of(:uid) }
      it { should validate_uniqueness_of(:uid).case_insensitive }
      it { should validate_length_of(:uid).is_at_most(255) }
    end
    describe "#twitter_id" do
      before { create(:user) } # pre-register to validate uniqueness
      it { should validate_presence_of(:twitter_id) }
      it { should validate_uniqueness_of(:twitter_id) }
      it { should validate_numericality_of(:twitter_id).is_greater_than_or_equal_to(0).only_integer }
    end
    describe "#provider" do
      it { should validate_presence_of(:provider) }
      it { should validate_length_of(:provider).is_at_most(255) }
    end
    describe "#name" do
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_most(255) }
    end
    describe "#screen_name" do
      it { should validate_presence_of(:screen_name) }
      it { should validate_length_of(:screen_name).is_at_most(255) }
    end
    describe "#protected_flag" do
      include_examples "should validate before_type_cast is a boolean", :user, :protected_flag
    end
    describe "#avatar_url" do
      it { should validate_presence_of(:avatar_url) }
      it { should validate_length_of(:avatar_url).is_at_most(255) }
    end
    describe "#twitter_created_at" do
      it { should validate_presence_of(:twitter_created_at) }
      it { should validate_numericality_of(:twitter_created_at).is_greater_than_or_equal_to(0).only_integer }
    end
    describe "#access_token" do
      it { should validate_presence_of(:access_token) }
      it { should validate_length_of(:access_token).is_at_most(255) }
    end
    describe "#access_token_secret" do
      it { should validate_presence_of(:access_token_secret) }
      it { should validate_length_of(:access_token_secret).is_at_most(255) }
    end
    describe "#token_updated_at" do
      it { should validate_numericality_of(:token_updated_at).is_greater_than_or_equal_to(0).only_integer.allow_nil }
    end
    describe "#statuses_updated_at" do
      it { should validate_numericality_of(:statuses_updated_at).is_greater_than_or_equal_to(0).only_integer.allow_nil }
    end
  end
  describe ".register_or_update!" do
    subject { User.register_or_update!(params) }
    context "register new user" do
      let(:valid_params) do
        {
          uid:                 "123456789",
          twitter_id:          123456789,
          provider:            "twitter",
          name:                "passed_name",
          screen_name:         "passed_screen_name",
          protected_flag:      true,
          avatar_url:          "passed_url",
          twitter_created_at:  "Thu Jul 4 00:00:00 +0000 2013",
          access_token:        "passed_access_token",
          access_token_secret: "passed_access_token_secret"
        }
      end
      context "failed to register" do
        let(:params) { valid_params.update(access_token: nil) }
        it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
        it "doesn't increase the total number of users" do
          expect { subject rescue nil }.not_to change { User.count }
        end
      end

      context "succeeded to register" do
        let(:params) { valid_params }
        it "increases the total number of users" do
          expect { subject }.to change { User.count }.by(1)
        end
        it "returns the registered user" do
          is_expected.to eq User.find_by(uid: params[:uid])
        end
      end
    end

    context "update existing user" do
      let!(:existing_user) { create(:user, **attrs_before_update) }
      let(:attrs_before_update) do
        {
          uid:                 "123456789",
          twitter_id:          123456789,
          provider:            "twitter",
          name:                "name_before_update",
          screen_name:         "screen_name_before_update",
          protected_flag:      false,
          avatar_url:          "url_before_update",
          twitter_created_at:  Time.zone.parse("Thu Jul 4 00:00:00 +0000 2013").to_i,
          access_token:        "access_token_before_update",
          access_token_secret: "access_token_secret_before_update",
          token_updated_at:    1482676460,
          statuses_updated_at: 1482676461
        }
      end
      let(:valid_params) do
        {
          uid:                 "123456789",
          twitter_id:          123456789,
          provider:            "twitter",
          name:                "name_after_update",
          screen_name:         "screen_name_after_update",
          protected_flag:      true,
          avatar_url:          "url_after_update",
          twitter_created_at:  "Thu Jul 4 00:00:00 +0000 2013",
          access_token:        "access_token_after_update",
          access_token_secret: "access_token_secret_after_update"
        }
      end
      context "failed to update" do
        let(:params) { valid_params.update(access_token: nil) }
        it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
        it "doesn't increase the total number of users" do
          expect { subject rescue nil }.not_to change { User.count }
        end
        it "doesn't change the targeting user at all" do
          expect { subject rescue nil }.not_to change { User.find_by!(uid: params[:uid]).attributes }
        end
      end

      context "succeeded to update" do
        let(:params) { valid_params }
        it "doesn't increase the total number of users" do
          expect { subject }.not_to change { User.count }
        end
        describe "all the attrs of targeting user are updated" do
          %i|name screen_name protected_flag avatar_url access_token access_token_secret|.each do |attr|
            it "updates ##{attr} with given one" do
              expect { subject }.to change { User.find_by!(uid: params[:uid]).send(attr) }.from(attrs_before_update[attr]).to(params[attr])
            end
          end
        end
        it "returns the targeting user" do
          is_expected.to eq User.find_by(uid: params[:uid])
        end
      end
    end
  end

  describe "#has_any_status?" do
    subject { user.has_any_status? }
    context "user has no status" do
      let!(:user) { create(:user) }
      it { is_expected.to be false }
    end
    context "user has some statuses" do
      let!(:user)     { create(:user) }
      let!(:statuses) { create_list(:status, 2, user: user) }
      it { is_expected.to be true }
    end
  end

  describe "#as_json" do
    subject { user.as_json }
    let(:name)           { "name" }
    let(:screen_name)    { "screen_name" }
    let(:avatar_url)     { "avatar_url" }
    let(:status_count)   { 100 }
    let(:followee_count) { 200 }
    let(:user) do
      create(:user,
        :with_statuses_and_followees,
        name:           name,
        screen_name:    screen_name,
        avatar_url:     avatar_url,
        status_count:   status_count,
        followee_count: followee_count
      )
    end

    it do
      is_expected.to include(
        name:           name,
        screen_name:    screen_name,
        avatar_url:     avatar_url,
        status_count:   status_count,
        followee_count: followee_count
      )
    end
  end
end

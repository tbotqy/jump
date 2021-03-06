# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:statuses).dependent(:destroy) }
    it { should have_many(:followees).dependent(:delete_all) }
    it { should have_one(:tweet_import_progress).dependent(:destroy) }
    it { should have_one(:tweet_import_lock).dependent(:destroy) }
    it { should have_many(:user_update_fail_logs).dependent(:delete_all) }
    it { should have_many(:hashtags).through(:statuses) }
    it { should have_many(:urls).through(:statuses) }
    it { should have_many(:media).through(:statuses) }
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
    describe "#profile_banner_url" do
      it { should validate_length_of(:profile_banner_url).is_at_most(255).allow_nil }
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

  describe ".not_protected" do
    subject { described_class.not_protected }
    context "no record matches" do
      before { create_list(:user, 3, protected_flag: true) }
      it { is_expected.to be_none }
      it_behaves_like "a scope"
    end
    context "some record matches" do
      let!(:public_users)    { create_list(:user, 3, protected_flag: false) }
      let!(:protected_users) { create_list(:user, 3, protected_flag: true) }
      it { is_expected.to contain_exactly(*public_users) }
      it_behaves_like "a scope"
    end
  end

  describe ".register_or_update!" do
    subject { User.register_or_update!(**params) }
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
          profile_banner_url:  "passed_banner_url",
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
          profile_banner_url:  "banner_url_before_update",
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
          profile_banner_url:  "banner_url_after_update",
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

  describe ".new_arrivals!" do
    subject { described_class.new_arrivals! }
    context "no user exists" do
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
    context "some users exist" do
      describe "only non-protected users are included" do
        let!(:protected_users) { create_list(:user, 2, protected_flag: true) }
        let!(:non_protected_users) { create_list(:user, 2, protected_flag: false) }
        it { is_expected.to contain_exactly(*non_protected_users) }
      end
      describe "number of returned items and their order" do
        before { (1..user_count).each { |n| create(:user, name: "#{n}th user") } }

        shared_examples "returns users ordered by from newest to oldest" do
          it do
            expect(subject.pluck(:name)).to eq (1..user_count).last(Settings.new_arrival_users_count).reverse.map { |n| "#{n}th user" }
          end
        end
        shared_examples "returns n users" do |n|
          it "returns #{n} users" do
            expect(subject.count).to eq n
          end
        end

        context "less than max" do
          let(:user_count) { Settings.new_arrival_users_count - 1 }
          include_examples "returns n users", Settings.new_arrival_users_count - 1
          it_behaves_like  "returns users ordered by from newest to oldest"
        end
        context "as much as max" do
          let(:user_count) { Settings.new_arrival_users_count }
          include_examples "returns n users", Settings.new_arrival_users_count
          it_behaves_like  "returns users ordered by from newest to oldest"
        end
        context "more than max" do
          let(:user_count) { Settings.new_arrival_users_count + 1 }
          include_examples "returns n users", Settings.new_arrival_users_count
          it_behaves_like  "returns users ordered by from newest to oldest"
        end
      end
    end
  end

  describe ".find_latest_by_screen_name!" do
    subject { described_class.find_latest_by_screen_name!(screen_name) }
    shared_examples "raises NotFound error" do
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "no user matches" do
      before { create(:user, screen_name: "existing_screen_name") }
      context "given a non-blank value" do
        let(:screen_name) { "imaginary_screen_name" }
        it_behaves_like "raises NotFound error"
      end
      context "given a blank value" do
        context "nil" do
          let(:screen_name) { nil }
          it_behaves_like "raises NotFound error"
        end
        context "blank string" do
          let(:screen_name) { "" }
          it_behaves_like "raises NotFound error"
        end
      end
    end
    context "only single user matches" do
      let(:screen_name) { create(:user).screen_name }
      it { expect { subject }.not_to raise_error }
      it { is_expected.to eq User.find_by!(screen_name: screen_name) }
    end
    context "several users match" do
      let(:screen_name) { "duplicating_screen_name" }
      let!(:older_user) { create(:user, screen_name: screen_name, updated_at: Time.zone.at(1)) }
      let!(:newer_user) { create(:user, screen_name: screen_name, updated_at: Time.zone.at(2)) }
      it { expect { subject }.not_to raise_error }
      it { is_expected.to eq newer_user }
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

  describe "#as_index_json" do
    subject { user.as_index_json }
    let(:name) { "name" }
    let(:screen_name) { "screen_name" }
    let(:avatar_url)  { "avatar_url" }
    let(:user) do
      create(:user,
        screen_name: screen_name,
        avatar_url:  avatar_url,
      )
    end
    it do
      is_expected.to include(
        screenName: screen_name,
        avatarUrl:  avatar_url
      )
    end
  end

  describe "#as_tweet_user_json" do
    subject { user.as_tweet_user_json }
    let(:name)        { "name" }
    let(:screen_name) { "screen_name" }
    let(:avatar_url)  { "avatar_url" }
    let(:user) do
      create(:user,
        name:        name,
        screen_name: screen_name,
        avatar_url:  avatar_url,
      )
    end
    it do
      is_expected.to include(
        name:        name,
        screenName: screen_name,
        avatarUrl:  avatar_url
      )
    end
  end

  describe "#as_json" do
    describe "required attributes" do
      subject { user.as_json }
      let(:name)           { "name" }
      let(:screen_name)    { "screen_name" }
      let(:avatar_url)     { "avatar_url" }
      let(:protected_flag) { true }
      let(:status_count)   { 100 }
      let(:followee_count) { 200 }
      let(:user) do
        create(:user,
          :with_statuses_and_followees,
          name:           name,
          screen_name:    screen_name,
          avatar_url:     avatar_url,
          protected_flag: protected_flag,
          status_count:   status_count,
          followee_count: followee_count
        )
      end

      it do
        is_expected.to include(
          id:            user.id,
          name:          name,
          screenName:    screen_name,
          avatarUrl:     avatar_url,
          protectedFlag: protected_flag,
          statusCount:   status_count.to_s(:delimited),
          followeeCount: followee_count.to_s(:delimited)
        )
      end
    end
    describe "nullable attributes" do
      describe "#profile_banner_url" do
        subject { user.as_json.fetch(:profileBannerUrl) }
        context "null" do
          let(:user) { create(:user, profile_banner_url: nil) }
          it { is_expected.to eq nil }
        end
        context "present" do
          let(:profile_banner_url) { "https://foo/bar" }
          let(:user) { create(:user, profile_banner_url: profile_banner_url) }
          it { is_expected.to eq profile_banner_url }
        end
      end
      describe "#statuses_updated_at" do
        subject { user.as_json.fetch(:statusesUpdatedAt) }
        context "null" do
          let(:user) { create(:user, statuses_updated_at: nil) }
          it { is_expected.to eq nil }
        end
        context "present" do
          let(:at) { 1 }
          let(:user) { create(:user, statuses_updated_at: at) }
          it { is_expected.to eq Time.zone.at(at).iso8601 }
        end
      end
      describe "#followees_updated_at" do
        subject { user.as_json.fetch(:followeesUpdatedAt) }
        context "null" do
          let(:user) { create(:user) } # user with no followee
          it { is_expected.to eq nil }
        end
        context "present" do
          let(:user) { create(:user) }
          before do
            create_list(:followee, 2, user: user)
            create_list(:followee, 2) # the another user's followees
          end
          it { is_expected.to eq user.followees.maximum(:created_at).iso8601 }
        end
      end
    end
  end

  describe "#admin?" do
    subject { user.admin? }

    let(:admin_user_twitter_id) { 12345 }
    before { allow(Settings).to receive(:admin_user_twitter_id).and_return(admin_user_twitter_id) }

    context "an admin" do
      let!(:user) { create(:user, twitter_id: admin_user_twitter_id, uid: admin_user_twitter_id.to_s) }
      it { is_expected.to eq true }
    end
    context "not an admin" do
      let(:twitter_id) { admin_user_twitter_id + 1 }
      let!(:user)      { create(:user, twitter_id: twitter_id, uid: twitter_id.to_s) }
      it { is_expected.to eq false }
    end
  end

  describe "#tokens" do
    subject { user.tokens }
    let(:access_token) { "access_token" }
    let(:access_token_secret) { "access_token_secret" }
    let(:user) { create(:user, access_token: access_token, access_token_secret: access_token_secret) }
    it { is_expected.to eq({ access_token: access_token, access_token_secret: access_token_secret }) }
  end

  describe "#twitter_client" do
    subject { create(:user).twitter_client }
    it { is_expected.to be_a(Twitter::REST::Client) }
  end
end

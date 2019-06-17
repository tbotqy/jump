# frozen_string_literal: true

require "rails_helper"

describe User do
  describe ".register_or_update!" do
    subject { User.register_or_update!(params) }
    context "register new user" do
      let(:valid_params) do
        {
          uid:                     "uid",
          twitter_id:              123456789,
          provider:                "twitter",
          name:                    "passed_name",
          screen_name:             "passed_screen_name",
          protected:               true,
          profile_image_url_https: "passed_url",
          twitter_created_at:      "Thu Jul 4 00:00:00 +0000 2013",
          token:                   "passed_token",
          token_secret:            "passed_token_secret"
        }
      end
      context "failed to register" do
        let(:params) { valid_params.update(token: nil) }
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
          uid:                     "uid",
          twitter_id:              123456789,
          provider:                "twitter",
          name:                    "name_before_update",
          screen_name:             "screen_name_before_update",
          protected:               false,
          profile_image_url_https: "url_before_update",
          twitter_created_at:      Time.zone.parse("Thu Jul 4 00:00:00 +0000 2013").to_i,
          token:                   "token_before_update",
          token_secret:            "token_secret_before_update",
          token_updated_at:        1482676460,
          statuses_updated_at:     1482676461,
          friends_updated_at:      1482774672,
          closed_only: false
        }
      end
      let(:valid_params) do
        {
          uid:                     "uid",
          twitter_id:              123456789,
          provider:                "twitter",
          name:                    "name_after_update",
          screen_name:             "screen_name_after_update",
          protected:               true,
          profile_image_url_https: "url_after_update",
          twitter_created_at:      "Thu Jul 4 00:00:00 +0000 2013",
          token:                   "token_after_update",
          token_secret:            "token_secret_after_update"
        }
      end
      context "failed to update" do
        let(:params) { valid_params.update(token: nil) }
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
          %i|name screen_name protected profile_image_url_https token token_secret|.each do |attr|
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
    subject { User.first.has_any_status? }
    context "user has any status" do
      before do
        FactoryBot.create(:user, :with_status)
      end
      it "returns true" do
        is_expected.to eq true
      end
    end
    context "user has no status" do
      before do
        FactoryBot.create(:user, :with_no_status)
      end
      it "returns false" do
        is_expected.to eq false
      end
    end
  end
end

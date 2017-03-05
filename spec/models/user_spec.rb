require 'rails_helper'
require 'lib'

RSpec.configure do |c|
  c.include Lib
end

describe User do

  describe "#has_friend?" do
    subject{User.first.has_friend?}
    context "user has some friend" do
      before do
        FactoryGirl.create(:user, :with_friend)
      end
      it "returns true" do
        is_expected.to eq true
      end
    end
    context "user has no friend" do
      before do
        FactoryGirl.create(:user, :with_no_friend)
      end
      it "returns false" do
        is_expected.to eq false
      end
    end
  end

  describe "#has_imported?" do
    subject{User.first.has_imported?}
    context "user has completed initial status import" do
      before do
        FactoryGirl.create(:user, :with_initial_import_completed)
      end
      it "returns true" do
        is_expected.to eq true
      end
    end
    context "user hasn't completed initial staus import" do
      before do
        FactoryGirl.create(:user, :with_initial_import_incompleted)
      end
      it "returns false" do
        is_expected.to eq false
      end
    end
  end

  describe "#has_any_status?" do
    subject{User.first.has_any_status?}
    context "user has any status" do
      before do
        FactoryGirl.create(:user, :with_status)
      end
      it "returns true" do
        is_expected.to eq true
      end
    end
    context "user has no status" do
      before do
        FactoryGirl.create(:user, :with_no_status)
      end
      it "returns false" do
        is_expected.to eq false
      end
    end
  end

  describe "#get_oldest_active_tweet_id" do
    pending "Will be replaced with other method."
  end

  describe "#get_active_status_count" do
    pending "Will be replaced with other method."
  end

  describe "create_account!" do
    it "increases the total numer of records in users table by 1" do
      expect{User.create_account!(auth_hash)}.to change{User.count}.by(1)
    end
  end

  describe "update_account" do
    it "updates a record with given auth_hash" do

    end
    it "doesn't inscrease the total number of records in users table" do

    end
  end

end

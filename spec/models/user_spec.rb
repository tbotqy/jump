require 'rails_helper'
require 'lib'

RSpec.configure do |c|
  c.include Lib
end

describe User do
  describe "#has_any_status?" do
    subject{User.first.has_any_status?}
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

  describe "#get_active_status_count" do
    pending "Will be replaced with other method."
  end

  describe "register_or_update!" do
    context "if given auth points the user not yet registered" do
      it "increases the total numer of records in users table by 1" do
        expect{User.register_or_update!(auth_hash)}.to change{User.count}.by(1)
      end
    end
    context "if given auth points the user already registered" do
      xit "doesn't increase the total numer of records in users" do
        expect{User.register_or_update!(auth_hash)}.not_to change{User.count}
      end
    end
  end
end

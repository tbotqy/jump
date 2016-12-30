require 'rails_helper'

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

end

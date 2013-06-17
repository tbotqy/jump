require 'spec_helper'

describe User do
  fixtures :users,:friends

  describe "check if user has friend or not" do
    before do
      @User = User.new
    end
    
    it "has friend" do
      expect(@user.find(:id=>1).has_friend?).to be_true
    end

    it "has no friend" do
      expect(@user.find(:id=>2).has_friend?).to be_false
    end
  end
end

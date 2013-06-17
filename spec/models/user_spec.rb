require 'spec_helper'

describe User do
  fixtures :all
  
  describe "test of has_friend?" do
    context "if user has friend" do
      it "returns true" do
        user = users(:one)
        expect(user.has_friend?).to be_true
      end
    end
    context "if user has no friend" do
      it "returns false" do
        user = users(:two)
        expect(user.has_friend?).to be_false
      end
    end
  end
  
  describe "test of has_imported?" do
    context "if user has finished importing" do
      it "returns true" do
        user = users(:one)
        expect(user.has_imported?).to be_true
      end
    end
    context "if user hasn't finished importing yet" do
      it "returns false" do
        user = users(:two)
        expect(user.has_imported?).to be_false
      end
    end
  end
  
  describe "test of create_account" do
    context "if valid data is given" do
      user = User.new
      omniauth = OmniAuth::AuthHash.new
      it "returns true" do
        pending("don't know how to create OmniAuth::AuthHash valid data")
        result = User::create_account(omniauth)
        expect(result).to be_true
      end
      it "increases total user count" do
        pending("don't know how to create OmniAuth::AuthHash valid data")
        expect{
          User::create_account(omniauth)
        }.to change(User, :count).by(1)
      end
    end
    context "if invalid data is given" do
      user = User.new
      it "returns false" do
        result = User::create_account(false)
        expect(result).to be_false
      end
      it "doesn't increase total user count" do
        expect{
          User::create_account(false)
        }.to change(User, :count).by(0)
      end
    end
  end

  describe "test of update_account" do
    context "if valid data is given" do
      user = User.new
      omniauth = OmniAuth::AuthHash.new
      it "returns true" do
        pending("don't know how to update OmniAuth::AuthHash valid data")
        result = User::update_account(omniauth)
        expect(result).to be_true
      end
      it "increases total user count" do
        pending("don't know how to update OmniAuth::AuthHash valid data")
        expect{
          User::update_account(omniauth)
        }.to change(User, :count).by(1)
      end
    end
    context "if invalid data is given" do
      user = User.new
      it "returns false" do
        result = User::update_account(false)
        expect(result).to be_false
      end

      it "doesn't increase total user count" do
        expect{
          User::update_account(false)
        }.to change(User, :count).by(0)
      end
    end
  
  end

  describe "test of deactivate_account" do
    context "if valid id is given" do
      result = User::deactivate_account(1)
      it "returns true" do
        expect(result).to be_true
      end
      it "turns deleted_flag to true" do
        expect{
          User.find(1).deleted_flag
        }.to be_true
      end 
    end
    context "if invalid id is given" do
      it "raises ActiveRecord::RecordNotFound exception" do
        expect{ User::deactivate_account(1000) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "test of twitter_id_exists?" do
    context "if given twitter id exists" do
      it "returns true" do
        result = User::twitter_id_exists?(1111)
        expect(result).to be_true
      end
    end
    context "if given twitter id doesn't exist" do
      it "returns false" do
        result = User::twitter_id_exists?(9999)
        expect(result).to be_false
      end
    end
  end

  describe "test of get_active_users" do
    context "if there is one active user" do
      it "returns object containing one record" do
        result = User::get_active_users
        expect(result).to have(1).items
      end
      it "all the returning records' deleted_flag is false" do
        active_users = User::get_active_users
        result = active_users.where(:deleted_flag => true).count
        expect(result).to eq(0)
      end
    end
    context "if there is no active user" do
      it "returns empty array" do
        User::deactivate_account(1)
        result = User::get_active_users
        expect(result).to be_empty
      end
    end
  end

  describe "test of get_gone_users" do
    context "if there is one gone user" do
      it "returns object containing one record" do
        result = User::get_gone_users
        expect(result).to have(1).items
      end
      it "all the returing records' deleted_flag is true" do
        gone_users = User::get_gone_users
        result = gone_users.where(:deleted_flag => false).count
        expect(result).to eq(0)
      end
    end
    context "if there is no gone user" do
      it "returns empty array" do
        pending("cannot turn the flag on the fly")
        result = User::get_gone_users
        expect(result).to be_empty
      end
    end
  end

end

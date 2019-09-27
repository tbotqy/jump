# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserTwitterClient do
  describe "#user_twitter_client" do
    subject { included_class.new.user_twitter_client }
    let(:included_class) { Class.new { include UserTwitterClient } }
    context "#user is not implemented in the included class" do
      it { expect { subject }.to raise_error("define me") }
    end
    context "#user is implemented in the included class" do
      context "user doesn't exist" do
        before { allow_any_instance_of(included_class).to receive(:user).and_raise(ActiveRecord::RecordNotFound) }
        it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
      end
      context "user exists" do
        context "user doesn't implement #access_token" do
          let(:user) { double("User") }
          before do
            allow(user).to receive(:access_token).and_raise(NoMethodError)
            allow(user).to receive(:access_token_secret).and_raise(NoMethodError)
            allow_any_instance_of(included_class).to receive(:user).and_return(user)
          end
          it { expect { subject }.to raise_error(NoMethodError) }
        end
        context "user implements #access_token" do
          context "user doesn't implement #access_token_secret" do
            let(:user) { double("User") }
            before do
              allow(user).to receive(:access_token).and_return("access token")
              allow(user).to receive(:access_token_secret).and_raise(NoMethodError)
              allow_any_instance_of(included_class).to receive(:user).and_return(user)
            end
            it { expect { subject }.to raise_error(NoMethodError) }
          end
        end
        context "user implements #access_token and #access_token_secret" do
          let(:user) { double("User", access_token: "access_token", access_token_secret: "access_token_secret") }
          before { allow_any_instance_of(included_class).to receive(:user).and_return(user) }
          it { is_expected.to be_a(TwitterClient) }
        end
      end
    end
  end
end

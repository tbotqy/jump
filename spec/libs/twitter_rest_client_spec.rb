# frozen_string_literal: true

require "rails_helper"

describe TwitterRestClient do
  describe ".by_user_id!" do
    subject { described_class.by_user_id!(user_id) }
    context "specified user doesn't exist" do
      let(:user_id) { 1 }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
    context "specified user exists" do
      let(:consumer_key)        { "consumer_key" }
      let(:consumer_secret)     { "consumer_secret" }
      let(:access_token)        { "access_token" }
      let(:access_token_secret) { "access_token_secret" }

      let!(:user_id) { create(:user, token: access_token, token_secret: access_token_secret).id }
      before do
        allow(Settings).to receive_message_chain(:twitter, :consumer_key).and_return(consumer_key)
        allow(Settings).to receive_message_chain(:twitter, :consumer_secret_key).and_return(consumer_secret)
      end
      it { is_expected.to be_a(Twitter::REST::Client) }
      it "has been configured to have all the credentials set" do
        is_expected.to have_attributes(
          consumer_key:        consumer_key,
          consumer_secret:     consumer_secret,
          access_token:        access_token,
          access_token_secret: access_token_secret
        )
      end
    end
  end
end

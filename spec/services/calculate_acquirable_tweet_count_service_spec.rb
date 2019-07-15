# frozen_string_literal: true

require "rails_helper"

RSpec.describe CalculateAcquirableTweetCountService do
  describe ".call!" do
    subject { CalculateAcquirableTweetCountService.call!(user_id: user_id) }
    context "user doesn't exist" do
      let!(:user)    { create(:user) }
      let!(:user_id) { User.maximum(:id) + 1 }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
    context "user exists" do
      let(:user)     { create(:user) }
      let!(:user_id) { user.id }
      before do
        allow_any_instance_of(Twitter::REST::Client).to receive_message_chain(:user, :tweets_count).and_return(total_tweet_count)
      end
      context "total tweet count < 3200" do
        let(:total_tweet_count) { 3199 }
        it { is_expected.to eq 3199 }
      end
      context "total tweet count == 3200" do
        let(:total_tweet_count) { 3200 }
        it { is_expected.to eq 3200 }
      end
      context "total tweet count > 3200" do
        let(:total_tweet_count) { 3201 }
        it { is_expected.to eq 3200 }
      end
    end
  end
end

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
        create_list(:status, existing_status_count, user: user)
        allow_any_instance_of(Twitter::REST::Client).to receive_message_chain(:user, :tweets_count).and_return(total_tweet_count)
      end
      context "existing status count > total tweet count" do
        let(:existing_status_count) { 10 }
        let(:total_tweet_count)     { 9 }
        it { is_expected.to eq 0 }
      end
      context "existing status count == total tweet count" do
        let(:existing_status_count) { 10 }
        let(:total_tweet_count)     { 10 }
        it { is_expected.to eq 0 }
      end
      context "existing status count < total tweet count" do
        context "diff > 3200" do
          let(:existing_status_count) { 1 }
          let(:total_tweet_count)     { 3202 }
          it { is_expected.to eq 3200 }
        end
        context "diff == 3200" do
          let(:existing_status_count) { 2 }
          let(:total_tweet_count)     { 3202 }
          it { is_expected.to eq 3200 }
        end
        context "diff < 3200" do
          let(:existing_status_count) { 3 }
          let(:total_tweet_count)     { 3202 }
          it { is_expected.to eq (3202 - 3) }
        end
      end
    end
  end
end

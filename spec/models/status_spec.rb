# frozen_string_literal: true

require "rails_helper"

describe Status do
  describe ".not_private" do
    subject { Status.not_private }
    context "no record matches" do
      before { create_list(:status, 3, private_flag: true) }
      it { is_expected.to be_none }
      it_behaves_like "a scope"
    end
    context "some record matches" do
      let!(:public_statuses)  { create_list(:status, 3, private_flag: false) }
      let!(:private_statuses) { create_list(:status, 3, private_flag: true) }
      it { is_expected.to contain_exactly(*public_statuses) }
      it_behaves_like "a scope"
    end
  end
  describe ".tweeted_at_or_before" do
    subject { Status.tweeted_at_or_before(targeting_time) }
    context "no record matches" do
      let(:targeting_time)                { Time.local(2019, 3, 1).beginning_of_day }
      let!(:tweeted_after_targeting_time) { create(:status, twitter_created_at: targeting_time.to_i + 1) }
      it { is_expected.to be_none }
      it_behaves_like "a scope"
    end
    context "some records match" do
      let(:targeting_time)                 { Time.local(2019, 3, 1).beginning_of_day }
      let!(:tweeted_before_targeting_time) { create(:status, twitter_created_at: targeting_time.to_i - 1) }
      let!(:tweeted_at_targeting_time)     { create(:status, twitter_created_at: targeting_time.to_i) }
      let!(:tweeted_after_targeting_time)  { create(:status, twitter_created_at: targeting_time.to_i + 1) }
      it { is_expected.to contain_exactly(tweeted_before_targeting_time, tweeted_at_targeting_time) }
      it_behaves_like "a scope"
    end
  end

  describe "#as_json" do
    subject { status.as_json }
    let(:status_id_str)      { 12345 }
    let(:text)               { "text" }
    let(:twitter_created_at) { Time.local(2019, 3, 1).to_i }
    let(:is_retweet)         { false }

    let!(:status) { create(:status, status_id_str: status_id_str, text: text, twitter_created_at: twitter_created_at, is_retweet: is_retweet) }

    context "status has no entity" do
      it do
        is_expected.to include(
          tweet_id:   status_id_str,
          text:       text,
          tweeted_at: Time.at(twitter_created_at),
          is_retweet: is_retweet,
          entities:   [],
          user:       status.user.as_json
        )
      end
    end

    context "status has some entities" do
      let!(:entities) { create_list(:entity, 3, status: status) }
      it do
        is_expected.to include(
          tweet_id:   status_id_str,
          text:       text,
          tweeted_at: Time.at(twitter_created_at),
          is_retweet: is_retweet,
          entities:   status.entities.as_json,
          user:       status.user.as_json
        )
      end
    end
  end
end

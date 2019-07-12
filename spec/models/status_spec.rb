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

  describe ".order_by_newest_to_oldest" do
    subject { Status.order_by_newest_to_oldest }

    shared_examples "orders statuses by tweet_id DESC" do
      it { expect(subject.pluck(:tweet_id)).to eq (1..5).to_a.reverse }
    end

    context "statuses are tweeted at the different times" do
      before do
        now = Time.now.utc.to_i
        create(:status, tweet_id: 1, twitter_created_at: now - 4.seconds)
        create(:status, tweet_id: 2, twitter_created_at: now - 3.seconds)
        create(:status, tweet_id: 3, twitter_created_at: now - 2.seconds)
        create(:status, tweet_id: 4, twitter_created_at: now - 1.second)
        create(:status, tweet_id: 5, twitter_created_at: now)
      end
      it_behaves_like "orders statuses by tweet_id DESC"
      it_behaves_like "a scope"
    end
    context "statuses are tweeted at the same time" do
      before do
        now = Time.now.utc.to_i
        [2, 4, 1, 5, 3].each do |tweet_id|
          create(:status, tweet_id: tweet_id, twitter_created_at: now)
        end
      end
      it_behaves_like "orders statuses by tweet_id DESC"
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

  describe ".most_recent_tweet_id!" do
    subject { Status.most_recent_tweet_id! }
    context "no status exists" do
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
    context "some statuses exist" do
      shared_examples "returns the tweet_id of the status whose tweet_id is bigger than the other's" do
        it { is_expected.to eq status_with_bigger_tweet_id.tweet_id }
      end
      describe "black box test" do
        context "there are some statuses tweeted at the different times" do
          let!(:now) { Time.now.utc.to_i }
          let!(:status_with_bigger_tweet_id)  { create(:status, tweet_id: 2, twitter_created_at: now) }
          let!(:status_with_smaller_tweet_id) { create(:status, tweet_id: 1, twitter_created_at: now - 1.seconds) }
          it_behaves_like "returns the tweet_id of the status whose tweet_id is bigger than the other's"
        end
        context "there are some statuses tweeted at the same time" do
          let!(:now) { Time.now.utc.to_i }
          let!(:status_with_bigger_tweet_id)  { create(:status, tweet_id: 2, twitter_created_at: now) }
          let!(:status_with_smaller_tweet_id) { create(:status, tweet_id: 1, twitter_created_at: now) }
          it_behaves_like "returns the tweet_id of the status whose tweet_id is bigger than the other's"
        end
      end
    end

    describe "user scope can be applied" do
      let!(:now) { Time.now.utc.to_i }
      let!(:user_with_some_statuses)       { create(:user) }
      let!(:the_most_recent_status)        { create(:status, user: user_with_some_statuses, twitter_created_at: now,            tweet_id: 2) }
      let!(:second_the_most_recent_status) { create(:status, user: user_with_some_statuses, twitter_created_at: now - 1.second, tweet_id: 1) }

      let!(:user_with_no_status)           { create(:user) }
      context "scoped by the user with some statuses" do
        subject { user_with_some_statuses.statuses.most_recent_tweet_id! }
        it { expect { subject }.not_to raise_error }
        it { is_expected.to eq the_most_recent_status.tweet_id }
      end
      context "scoped by the user with no status" do
        subject { user_with_no_status.statuses.most_recent_tweet_id! }
        it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end
  end

  describe "#as_json" do
    subject { status.as_json }
    let(:tweet_id)           { 12345 }
    let(:text)               { "text" }
    let(:twitter_created_at) { Time.local(2019, 3, 1).to_i }
    let(:is_retweet)         { false }

    let!(:status) { create(:status, tweet_id: tweet_id, text: text, twitter_created_at: twitter_created_at, is_retweet: is_retweet) }

    context "status has no entity" do
      it do
        is_expected.to include(
          tweet_id:   tweet_id,
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
          tweet_id:   tweet_id,
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

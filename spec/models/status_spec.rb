# frozen_string_literal: true

require "rails_helper"

RSpec.describe Status, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:hashtags).dependent(:delete_all) }
    it { should have_many(:urls).dependent(:delete_all) }
    it { should have_many(:media).dependent(:delete_all) }
    it { should have_many(:entities).dependent(:delete_all) }
  end

  describe "validations" do
    describe "#tweet_id" do
      before { create(:status) } # pre-resgiter to validate uniqueness
      it { should validate_presence_of(:tweet_id) }
      it { should validate_uniqueness_of(:tweet_id) }
      it { should validate_numericality_of(:tweet_id).is_greater_than_or_equal_to(0).only_integer }
    end
    describe "#in_reply_to_tweet_id" do
      it { should validate_numericality_of(:in_reply_to_tweet_id).is_greater_than_or_equal_to(0).only_integer.allow_nil }
    end
    describe "#in_reply_to_user_id_str" do
      it { should validate_numericality_of(:in_reply_to_user_id_str).is_greater_than_or_equal_to(0).only_integer.allow_nil }
    end
    describe "#in_reply_to_screen_name" do
      it { should validate_length_of(:in_reply_to_screen_name).is_at_most(255).allow_nil }
    end
    describe "#place_full_name" do
      it { should validate_length_of(:place_full_name).is_at_most(255).allow_nil }
    end
    describe "#retweet_count" do
      it { should validate_numericality_of(:retweet_count).is_greater_than_or_equal_to(0).only_integer.allow_nil }
    end
    describe "#source" do
      it { should validate_presence_of(:source) }
      it { should validate_length_of(:source).is_at_most(255) }
    end
    describe "#text" do
      it { should validate_presence_of(:text) }
      it { should validate_length_of(:text).is_at_most(280) }
    end
    describe "#is_retweet" do
      include_examples "should validate before_type_cast is a boolean", :status, :is_retweet
    end
    describe "#rt_*" do
      context "a retweet" do
        before { allow(subject).to receive(:is_retweet?).and_return(true) }
        describe "#rt_name" do
          it { should validate_presence_of(:rt_name) }
          it { should validate_length_of(:rt_name).is_at_most(280) }
        end
        describe "#rt_screen_name" do
          it { should validate_presence_of(:rt_screen_name) }
          it { should validate_length_of(:rt_screen_name).is_at_most(255) }
        end
        describe "#rt_avatar_url" do
          it { should validate_presence_of(:rt_avatar_url) }
          it { should validate_length_of(:rt_avatar_url).is_at_most(255) }
        end
        describe "#rt_text" do
          it { should validate_presence_of(:rt_text) }
          it { should validate_length_of(:rt_text).is_at_most(255) }
        end
        describe "#rt_source" do
          it { should validate_presence_of(:rt_source) }
          it { should validate_length_of(:rt_source).is_at_most(255) }
        end
        describe "#rt_created_at" do
          it { should validate_presence_of(:rt_created_at) }
          it { should validate_numericality_of(:rt_created_at).is_greater_than_or_equal_to(0).only_integer }
        end
      end
      context "a non-retweet" do
        before { allow(subject).to receive(:is_retweet?).and_return(false) }
        describe "#rt_name" do
          it { should validate_absence_of(:rt_name) }
        end
        describe "#rt_screen_name" do
          it { should validate_absence_of(:rt_screen_name) }
        end
        describe "#rt_avatar_url" do
          it { should validate_absence_of(:rt_avatar_url) }
        end
        describe "#rt_text" do
          it { should validate_absence_of(:rt_text) }
        end
        describe "#rt_source" do
          it { should validate_absence_of(:rt_source) }
        end
        describe "#rt_created_at" do
          it { should validate_absence_of(:rt_created_at) }
        end
      end
    end
    describe "#possibly_sensitive" do
      include_examples "should validate before_type_cast is a boolean", :status, :possibly_sensitive
    end
    describe "#private_flag" do
      include_examples "should validate before_type_cast is a boolean", :status, :private_flag
    end
    describe "#tweeted_at" do
      it { should validate_presence_of(:tweeted_at) }
      it { should validate_numericality_of(:tweeted_at).is_greater_than_or_equal_to(0).only_integer }
    end
    describe "#tweet_id_reversed" do
      it { should validate_presence_of(:tweet_id_reversed) }
      it { should validate_numericality_of(:tweet_id_reversed).is_less_than_or_equal_to(0).only_integer }
    end
    describe "#tweeted_at_reversed" do
      it { should validate_presence_of(:tweeted_at_reversed) }
      it { should validate_numericality_of(:tweeted_at_reversed).is_less_than_or_equal_to(0).only_integer }
    end
    describe "#tweeted_on" do
      it { should validate_presence_of(:tweeted_on) }
    end
  end

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
        now = Time.current.to_i
        create(:status, tweet_id: 1, tweeted_at: now - 4.seconds)
        create(:status, tweet_id: 2, tweeted_at: now - 3.seconds)
        create(:status, tweet_id: 3, tweeted_at: now - 2.seconds)
        create(:status, tweet_id: 4, tweeted_at: now - 1.second)
        create(:status, tweet_id: 5, tweeted_at: now)
      end
      it_behaves_like "orders statuses by tweet_id DESC"
      it_behaves_like "a scope"
    end
    context "statuses are tweeted at the same time" do
      before do
        now = Time.current.to_i
        [2, 4, 1, 5, 3].each do |tweet_id|
          create(:status, tweet_id: tweet_id, tweeted_at: now)
        end
      end
      it_behaves_like "orders statuses by tweet_id DESC"
      it_behaves_like "a scope"
    end
  end

  describe ".tweeted_at_or_before" do
    subject { Status.tweeted_at_or_before(targeting_time) }
    context "no record matches" do
      let(:targeting_time)                { Time.zone.local(2019, 3, 1).beginning_of_day }
      let!(:tweeted_after_targeting_time) { create(:status, tweeted_at: targeting_time.to_i + 1) }
      it { is_expected.to be_none }
      it_behaves_like "a scope"
    end
    context "some records match" do
      let(:targeting_time)                 { Time.zone.local(2019, 3, 1).beginning_of_day }
      let!(:tweeted_before_targeting_time) { create(:status, tweeted_at: targeting_time.to_i - 1) }
      let!(:tweeted_at_targeting_time)     { create(:status, tweeted_at: targeting_time.to_i) }
      let!(:tweeted_after_targeting_time)  { create(:status, tweeted_at: targeting_time.to_i + 1) }
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
          let!(:now) { Time.current.to_i }
          let!(:status_with_bigger_tweet_id)  { create(:status, tweet_id: 2, tweeted_at: now) }
          let!(:status_with_smaller_tweet_id) { create(:status, tweet_id: 1, tweeted_at: now - 1.seconds) }
          it_behaves_like "returns the tweet_id of the status whose tweet_id is bigger than the other's"
        end
        context "there are some statuses tweeted at the same time" do
          let!(:now) { Time.current.to_i }
          let!(:status_with_bigger_tweet_id)  { create(:status, tweet_id: 2, tweeted_at: now) }
          let!(:status_with_smaller_tweet_id) { create(:status, tweet_id: 1, tweeted_at: now) }
          it_behaves_like "returns the tweet_id of the status whose tweet_id is bigger than the other's"
        end
      end
    end

    describe "user scope can be applied" do
      let!(:now) { Time.current.to_i }
      let!(:user_with_some_statuses)       { create(:user) }
      let!(:the_most_recent_status)        { create(:status, user: user_with_some_statuses, tweeted_at: now,            tweet_id: 2) }
      let!(:second_the_most_recent_status) { create(:status, user: user_with_some_statuses, tweeted_at: now - 1.second, tweet_id: 1) }

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
    describe "top level attributes" do
      context "status is not a retweet" do
        let(:tweet_id)    { 12345 }
        let(:text)        { "text" }
        let!(:tweeted_at) { Time.current.to_i }
        let(:is_retweet)  { false }
        let!(:status) do
          create(:status,
            tweet_id:       tweet_id,
            text:           text,
            tweeted_at:     tweeted_at,
            is_retweet:     is_retweet,
            rt_avatar_url:  nil,
            rt_name:        nil,
            rt_screen_name: nil,
            rt_text:        nil,
            rt_source:      nil,
            rt_created_at:  nil
          )
        end

        it do
          is_expected.to include(
            tweet_id:       tweet_id.to_s,
            text:           text,
            tweeted_at:     Time.zone.at(tweeted_at).iso8601,
            is_retweet:     is_retweet,
          )
        end
        it do
          is_expected.not_to include(
            rt_name:        nil,
            rt_screen_name: nil,
            rt_text:        nil,
            rt_source:      nil,
            rt_created_at:  nil
          )
        end
      end
      context "status is a retweet" do
        let(:tweet_id)       { 12345 }
        let(:text)           { "text" }
        let!(:tweeted_at)    { Time.current.to_i }
        let(:is_retweet)     { true }
        let(:rt_avatar_url)  { "rt_avatar_url" }
        let(:rt_name)        { "rt_name" }
        let(:rt_screen_name) { "rt_screen_name" }
        let(:rt_text)        { "rt_text" }
        let(:rt_source)      { "rt_source" }
        let!(:rt_created_at) { (Time.current - 1.day).to_i }
        let!(:status) do
          create(:status,
            tweet_id:       tweet_id,
            text:           text,
            tweeted_at:     tweeted_at,
            is_retweet:     is_retweet,
            rt_avatar_url:  rt_avatar_url,
            rt_name:        rt_name,
            rt_screen_name: rt_screen_name,
            rt_text:        rt_text,
            rt_source:      rt_source,
            rt_created_at:  rt_created_at
          )
        end
        it do
          is_expected.to include(
            tweet_id:       tweet_id.to_s,
            text:           text,
            tweeted_at:     Time.zone.at(tweeted_at).iso8601,
            is_retweet:     is_retweet,
            rt_name:        rt_name,
            rt_screen_name: rt_screen_name,
            rt_text:        rt_text,
            rt_source:      rt_source,
            rt_created_at:  Time.zone.at(rt_created_at).iso8601
          )
        end
      end
    end

    describe "associations" do
      describe "user" do
        let!(:user)   { create(:user) }
        let!(:status) { create(:status, user: user) }
        it { is_expected.to include(user: user.as_json) }
      end
      describe "entities" do
        pending "TODO: specify"
      end
    end
  end
end

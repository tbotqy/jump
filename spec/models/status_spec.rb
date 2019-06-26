# frozen_string_literal: true

require "rails_helper"

describe Status do
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

  describe ".tweeted_in" do
    subject { Status.tweeted_in(date_string) }
    context "only year is given" do
      let(:date_string) { "2019" }
      let!(:status_2018_12_31) { create(:status, twitter_created_at: Time.zone.local(2018, 12, 31, 23, 59, 59).to_i) }
      let!(:status_2019_1_1)   { create(:status, twitter_created_at: Time.zone.local(2019,  1,  1).to_i) }
      let!(:status_2019_12_31) { create(:status, twitter_created_at: Time.zone.local(2019, 12, 31, 23, 59, 59).to_i) }
      let!(:status_2020_1_1)   { create(:status, twitter_created_at: Time.zone.local(2020,  1,  1).to_i) }
      it "covers specified year" do
        is_expected.to contain_exactly(status_2019_1_1, status_2019_12_31)
      end
    end
    context "year and month are given" do
      let(:date_string) { "2019-5" }
      let!(:status_2019_4_30) { create(:status, twitter_created_at: Time.zone.local(2019, 4, 30, 23, 59, 59).to_i) }
      let!(:status_2019_5_1)  { create(:status, twitter_created_at: Time.zone.local(2019, 5,  1).to_i) }
      let!(:status_2019_5_31) { create(:status, twitter_created_at: Time.zone.local(2019, 5, 31, 23, 59, 59).to_i) }
      let!(:status_2019_6_1)  { create(:status, twitter_created_at: Time.zone.local(2019, 6,  1).to_i) }
      it "covers specified month" do
        is_expected.to contain_exactly(status_2019_5_1, status_2019_5_31)
      end
    end
    context "year and month and day are given" do
      let(:date_string) { "2019-5-2" }
      let!(:status_2019_5_1_23_59) { create(:status, twitter_created_at: Time.zone.local(2019, 5, 1, 23, 59, 59).to_i) }
      let!(:status_2019_5_2_0_0)   { create(:status, twitter_created_at: Time.zone.local(2019, 5, 2).to_i) }
      let!(:status_2019_5_2_23_59) { create(:status, twitter_created_at: Time.zone.local(2019, 5, 2, 23, 59, 59).to_i) }
      let!(:status_2019_5_3_0_0)   { create(:status, twitter_created_at: Time.zone.local(2019, 5, 3).to_i) }
      it "covers specified day" do
        is_expected.to contain_exactly(status_2019_5_2_0_0, status_2019_5_2_23_59)
      end
    end
  end

  describe ".date_range_of" do
    subject { Status.send(:date_range_of, date_string) }
    context "only year is given" do
      let(:date_string) { "2019" }
      it "covers specified year" do
        is_expected.to eq Time.zone.local(2019).all_year
      end
    end
    context "year and month are given" do
      let(:date_string) { "2019-5" }
      it "covers specified month" do
        is_expected.to eq Time.zone.local(2019, 5).all_month
      end
    end
    context "year and month and day are given" do
      let(:date_string) { "2019-5-2" }
      it "covers specified day" do
        is_expected.to eq Time.zone.local(2019, 5, 2).all_day
      end
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

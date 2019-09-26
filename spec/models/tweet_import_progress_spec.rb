# frozen_string_literal: true

require "rails_helper"

RSpec.describe TweetImportProgress, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:statuses).through(:user) }
  end

  describe "validations" do
    describe "#user_id" do
      before { create(:tweet_import_progress) }
      it { should validate_uniqueness_of(:user_id) }
    end
    describe "#finished" do
      include_examples "should validate before_type_cast is a boolean", :tweet_import_progress, :finished
    end
  end

  describe "callbacks" do
    context "after destroy" do
      describe "deletes the data on Redis that is related to the record" do
        subject { -> { record.destroy! } }
        let!(:record) { create(:tweet_import_progress) }

        describe "#current_count" do
          let(:redis_key) { record.current_count.key }
          before { record.current_count.increment }
          it { is_expected.to change { REDIS.get(redis_key) }.from("1").to(nil) }
        end

        describe "#last_tweet_id" do
          let(:redis_key) { record.last_tweet_id.key }
          before { record.last_tweet_id = "12345" }
          it { is_expected.to change { REDIS.get(redis_key) }.from("12345").to(nil) }
        end
      end
    end
  end

  describe "#percentage" do
    subject do
      record = create(:tweet_import_progress)
      record.current_count.reset(count)
      record.percentage
    end

    describe "the return value is floor-ed" do
      # in this test, the denominator of percentage is expected to be 3200
      # , which is defined by Settings.twitter.traceable_tweet_count_limit

      context "real result must have been less than 1%" do
        let(:count) { 31 }
        it { is_expected.to eq 0 }
      end
      context "real result must have been eq to 1%" do
        let(:count) { 32 }
        it { is_expected.to eq 1 }
      end
      context "real result must have been bigger than 1%" do
        let(:count) { 33 }
        it { is_expected.to eq 1 }
      end
    end

    describe "boundary test on count around traceable_tweet_count_limit" do
      let(:traceable_tweet_count_limit) { Settings.twitter.traceable_tweet_count_limit } # = 3200

      shared_examples "it doesn't become bigger than 100" do
        it { is_expected.to eq 100 }
      end

      context "count < traceable_tweet_count_limit" do
        let(:count) { traceable_tweet_count_limit - 1 }
        it "returns a real calculation result" do
          is_expected.to eq 99
        end
      end

      context "count == traceable_tweet_count_limit" do
        let(:count) { traceable_tweet_count_limit }
        it { is_expected.to eq 100 }
      end

      context "count > traceable_tweet_count_limit" do
        let(:count) { traceable_tweet_count_limit + 1 }
        it_behaves_like "it doesn't become bigger than 100"
      end

      context "count >> traceable_tweet_count_limit" do
        let(:count) { traceable_tweet_count_limit + 3300 }
        it_behaves_like "it doesn't become bigger than 100"
      end
    end

    describe "initial state" do
      let(:count) { 0 }
      it { is_expected.to eq 0 }
    end
  end

  describe "#as_json" do
    subject { tweet_import_progress.as_json }
    context "no status has been imported" do
      let!(:tweet_import_progress) { create(:tweet_import_progress) }
      it do
        is_expected.to include(
          percentage:    0,
          finished:      false,
          last_tweet_id: nil
        )
      end
    end
    context "statuses are being imported" do
      let(:user)                  { create(:user) }
      let!(:statuses)             { create_list(:status, assumed_imported_status_count, user: user) }
      let(:tweet_import_progress) { create(:tweet_import_progress, user: user) }

      let(:assumed_imported_status_count) { 33 }
      let(:expected_percentage)           { 1 } # (33/3200(=traceable_tweet_count_limit).to_f).floor
      let(:last_tweet_id) { "12345" }
      before do
        tweet_import_progress.current_count.reset(assumed_imported_status_count)
        tweet_import_progress.last_tweet_id = last_tweet_id
      end
      it do
        is_expected.to include(
          percentage:    expected_percentage,
          finished:      false,
          last_tweet_id: last_tweet_id
        )
      end
    end
    context "status import has been finished" do
      let(:user)                  { create(:user) }
      let!(:statuses)             { create_list(:status, total_imported_count, user: user) }
      let(:tweet_import_progress) { create(:tweet_import_progress, finished: true, user: user) }

      let(:total_imported_count) { 33 }
      let(:expected_percentage)  { 1 } # (33/3200(=traceable_tweet_count_limit).to_f).floor
      let(:last_tweet_id) { "12345" }
      before do
        tweet_import_progress.current_count.reset(total_imported_count)
        tweet_import_progress.last_tweet_id = last_tweet_id
      end
      it do
        is_expected.to include(
          percentage:    expected_percentage,
          finished:      true,
          last_tweet_id: last_tweet_id
        )
      end
    end
  end

  describe "#mark_as_finished!" do
    subject { -> { tweet_import_progress.mark_as_finished! } }
    let!(:tweet_import_progress) { create(:tweet_import_progress, finished: false) }
    it { is_expected.to change { tweet_import_progress.finished? }.from(false).to(true) }
  end

  describe "#percentage_denominator" do
    subject { create(:tweet_import_progress).send(:percentage_denominator) }
    it "should be eq with the limit of tweet count that is traceable via Twitter API" do
      is_expected.to eq 3200
    end
  end

  describe "#increment_by" do
    subject { -> { tweet_import_progress.increment_by(number) } }
    let!(:tweet_import_progress) { create(:tweet_import_progress) }
    let(:number) { 10 }
    it { is_expected.to change { tweet_import_progress.current_count.value }.by(number) }
  end
end

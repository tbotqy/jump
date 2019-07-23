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
    describe "#count" do
      it { should validate_presence_of(:count) }
      it { should validate_numericality_of(:count).is_greater_than_or_equal_to(0).only_integer }
    end
    describe "#percentage_denominator" do
      it { should validate_presence_of(:percentage_denominator) }
      it { should validate_numericality_of(:percentage_denominator).is_greater_than(0).only_integer }
    end
    describe "#finished" do
      include_examples "should validate before_type_cast is a boolean", :tweet_import_progress, :finished
    end
  end

  describe "#percentage" do
    subject { create(:tweet_import_progress, count: count, percentage_denominator: percentage_denominator).percentage }

    shared_examples "raises custom error with expected message" do
      it { expect { subject }.to raise_error("Calculating with some negative value. (count: #{count}, percentage_denominator: #{percentage_denominator})") }
    end

    describe "boundary test on count around 0 and :percentage_denominator" do
      shared_examples "calculates as expected" do
        it { is_expected.to eq ((count / percentage_denominator.to_f) * 100).floor  }
      end

      context "count == 0" do
        let(:count) { 0 }
        let(:percentage_denominator) { 3200 }
        it { is_expected.to be_an(Integer) }
        it { is_expected.to eq 0 }
      end

      context "count == 0 + 1" do
        let(:count) { 1 }
        let(:percentage_denominator) { 3200 }
        it { is_expected.to be_an(Integer) }
        it_behaves_like "calculates as expected"
      end

      context "count == percentage_denominator - 1" do
        let(:count) { percentage_denominator - 1 }
        let(:percentage_denominator) { 3200 }
        it { is_expected.to be_an(Integer) }
        it_behaves_like "calculates as expected"
      end

      context "count == percentage_denominator" do
        let(:count) { percentage_denominator }
        let(:percentage_denominator) { 3200 }
        it { is_expected.to be_an(Integer) }
        it_behaves_like "calculates as expected"
      end

      context "count == percentage_denominator + 1" do
        let(:count) { percentage_denominator + 1 }
        let(:percentage_denominator) { 3200 }
        it { is_expected.to be_an(Integer) }
        it { is_expected.to eq 100 }
      end

      context "count >> percentage_denominator" do
        let(:count) { percentage_denominator + 3300 }
        let(:percentage_denominator) { 3200 }
        it { is_expected.to be_an(Integer) }
        it { is_expected.to eq 100 }
      end
    end
  end

  describe "#as_json" do
    subject { tweet_import_progress.as_json }
    context "no status has been imported" do
      let(:user)                   { create(:user) }
      let!(:tweet_import_progress) { create(:tweet_import_progress, count: 0, user: user) }
      it do
        is_expected.to include(
          percentage:  0,
          last_status: {},
          user:        user.as_json
        )
      end
    end
    context "some status has been imported" do
      let(:user)                  { create(:user) }
      let!(:statuses)             { create_list(:status, assumed_imported_status_count, user: user) }
      let!(:entities)             { statuses.each { |status| create(:entity, status: status) } }
      let(:tweet_import_progress) { create(:tweet_import_progress, user: user, count: assumed_imported_status_count, percentage_denominator: percentage_denominator) }

      let(:assumed_imported_status_count) { 3 }
      let(:percentage_denominator)        { 200 }
      let(:expected_percentage)           { 1 } # (3/200.to_f).floor
      it do
        is_expected.to include(
          percentage:  expected_percentage,
          last_status: statuses.last.as_json,
          user:        user.as_json
        )
      end
    end
  end

  describe "#mark_as_finished!" do
    subject { -> { tweet_import_progress.mark_as_finished! } }
    let!(:tweet_import_progress) { create(:tweet_import_progress, finished: false) }
    it do
      is_expected.to change { tweet_import_progress.finished }.from(false).to(true)
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe TweetImportJobProgress, type: :model do
  describe "validation" do
    describe "on percentage_denominator" do
      subject { -> { TweetImportJobProgress.create!(user: create(:user), job_id: "123", percentage_denominator: percentage_denominator) } }
      context "not specified" do
        context "blank string" do
          let(:percentage_denominator) { "" }
          it { is_expected.to raise_error(ActiveRecord::RecordInvalid, /Percentage denominator can't be blank, Percentage denominator is not a number/) }
        end
        context "nil" do
          let(:percentage_denominator) { nil }
          it { is_expected.to raise_error(ActiveRecord::RecordInvalid, /Percentage denominator can't be blank, Percentage denominator is not a number/) }
        end
      end
      context "zero" do
        let(:percentage_denominator) { 0 }
        it { is_expected.to raise_error(ActiveRecord::RecordInvalid, /Percentage denominator must be other than 0/) }
      end
      context "some number" do
        let(:percentage_denominator) { 3200 }
        it { is_expected.not_to raise_error }
      end
    end
  end

  describe "#percentage" do
    subject { create(:tweet_import_job_progress, count: count, percentage_denominator: percentage_denominator).percentage }

    shared_examples "raises custom error with expected message" do
      it { expect { subject }.to raise_error("Calculating with some negative value. (count: #{count}, percentage_denominator: #{percentage_denominator})") }
    end

    describe "boundary test on count around 0 and :percentage_denominator" do
      shared_examples "calculates as expected" do
        it { is_expected.to eq ((count / percentage_denominator.to_f) * 100).floor  }
      end

      context "count < 0" do
        let(:count) { -1 }
        let(:percentage_denominator) { 3200 }
        it_behaves_like "raises custom error with expected message"
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

    describe "invalid value handling" do
      context "only count is a negative number" do
        let(:count) { -1 }
        let(:percentage_denominator) { 3200 }
        it_behaves_like "raises custom error with expected message"
      end
      context "only percentage_denominator is a negative number" do
        let(:count) { 1 }
        let(:percentage_denominator) { -3200 }
        it_behaves_like "raises custom error with expected message"
      end
      context "both of count and percentage_denominator is a negative number" do
        let(:count) { -1 }
        let(:percentage_denominator) { -3200 }
        it_behaves_like "raises custom error with expected message"
      end
    end
  end

  describe "#as_json" do
    subject { tweet_import_job_progress.as_json }
    context "no status has been imported" do
      let(:user)                       { create(:user) }
      let!(:tweet_import_job_progress) { create(:tweet_import_job_progress, count: 0, user: user) }
      it do
        is_expected.to include(
          percentage:  0,
          last_status: {},
          user:        user.as_json
        )
      end
    end
    context "some status has been imported" do
      let(:user)                       { create(:user) }
      let!(:statuses)                  { create_list(:status, assumed_imported_status_count, user: user) }
      let!(:entities)                  { statuses.each { |status| create(:entity, status: status) } }
      let(:tweet_import_job_progress)  { create(:tweet_import_job_progress, user: user, count: assumed_imported_status_count, percentage_denominator: percentage_denominator) }

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
end

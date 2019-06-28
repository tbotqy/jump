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
end

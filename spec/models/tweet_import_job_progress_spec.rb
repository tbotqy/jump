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
end

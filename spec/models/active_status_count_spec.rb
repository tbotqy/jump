# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActiveStatusCount do
  describe "increment_by" do
    subject { -> { described_class.increment_by(param) } }
    shared_examples "increments current_count by given param" do
      it { is_expected.to change { described_class.current_count }.by(param.to_i) }
    end
    context "given a number" do
      let(:param) { 10 }
      it_behaves_like "increments current_count by given param"
    end
    context "given a numeric string" do
      let(:param) { "10" }
      it_behaves_like "increments current_count by given param"
    end
    context "given an un-numeric string" do
      let(:param) { "あ" }
      it { is_expected.to raise_error(Redis::CommandError, "ERR value is not an integer or out of range") }
    end
  end
  describe "current_count" do
    subject { described_class.current_count }
    context "with initial state" do
      it { is_expected.to eq 0 }
    end
    context "with statuses counted up" do
      let(:status_count) { 3 }
      before do
        create_list(:status, status_count)
        described_class.count_up
      end
      it { is_expected.to eq status_count }
    end
  end
  describe "count_up" do
    subject { -> { described_class.count_up } }
    context "initial call" do
      let(:status_count) { 3 }
      before { create_list(:status, status_count) }
      it { is_expected.to change { described_class.current_count }.by(status_count) }
    end
    context "non-initial call" do
      context "total number of statuses has increased since the previous counting up" do
        let(:before_status_count)    { 3 }
        let(:increased_status_count) { 2 }
        before do
          create_list(:status, before_status_count)
          described_class.count_up
          create_list(:status, increased_status_count)
        end
        it { is_expected.to change { described_class.current_count }.by(increased_status_count) }
      end
      context "total number of statuses has decreased since the previous counting up" do
        let(:before_status_count)    { 3 }
        let(:decreased_status_count) { 2 }
        before do
          statuses = create_list(:status, before_status_count)
          described_class.count_up
          statuses.first(decreased_status_count).each(&:destroy!)
        end
        it { is_expected.to change { described_class.current_count }.by(-1 * decreased_status_count) }
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

describe MyProgressBar do
  describe ".create" do
    subject { described_class.create(total: total) }
    let(:total) { 10 }
    let(:format) { "%t: |%B| %a %E  %c/%C %P%%" }
    before do
      allow(ProgressBar).to receive(:create).with(total: total, format: format)
    end
    it "creates a ProgressBar instance" do
      subject
      expect(ProgressBar).to have_received(:create).with(total: total, format: format)
    end
  end
end

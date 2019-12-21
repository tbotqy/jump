# frozen_string_literal: true

require "rails_helper"

RSpec.describe Medium, type: :model do
  describe "associations" do
    it { should belong_to(:status) }
  end

  describe "validations" do
    describe "#url" do
      it { should validate_presence_of(:url) }
      it { should validate_length_of(:url).is_at_most(255) }
    end
    describe "#direct_url" do
      it { should validate_length_of(:direct_url).is_at_most(255) }
    end
    describe "#display_url" do
      it { should validate_presence_of(:display_url) }
      it { should validate_length_of(:display_url).is_at_most(255) }
    end
    include_examples "validation on indices"
  end

  describe "#as_json" do
    subject { record.as_json }
    let!(:record)     { create(:medium, url: url, display_url: display_url, direct_url: direct_url, index_f: index_f, index_l: index_l) }
    let(:url)         { "url" }
    let(:display_url) { "display_url" }
    let(:direct_url)  { "direct_url" }
    let(:index_f)    { 1 }
    let(:index_l)    { 10 }
    it do
      is_expected.to include(
        url:        url,
        displayUrl: display_url,
        indices:    [index_f, index_l]
      )
    end
  end
end

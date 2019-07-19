# frozen_string_literal: true

require "rails_helper"

RSpec.describe Url, type: :model do
  describe "associations" do
    it { should belong_to(:status) }
  end

  describe "validations" do
    describe "#url" do
      it { should validate_presence_of(:url) }
      it { should validate_length_of(:url).is_at_most(255) }
    end
    describe "#display_url" do
      it { should validate_presence_of(:display_url) }
      it { should validate_length_of(:display_url).is_at_most(255) }
    end
    include_examples "validation on indices"
  end
end

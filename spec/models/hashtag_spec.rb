# frozen_string_literal: true

require "rails_helper"

RSpec.describe Hashtag, type: :model do
  describe "associations" do
    it { should belong_to(:status) }
  end

  describe "validations" do
    describe "#text" do
      it { should validate_presence_of(:text) }
      it { should validate_length_of(:text).is_at_most(255) }
    end
    include_examples "validation on indices"
  end
end

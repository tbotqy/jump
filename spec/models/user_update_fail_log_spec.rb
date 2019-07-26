# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserUpdateFailLog, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    describe "#error_message" do
      it { should validate_presence_of(:error_message) }
      it { should validate_length_of(:error_message).is_at_most(255) }
    end
  end
end

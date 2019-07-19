# frozen_string_literal: true

require "rails_helper"

RSpec.describe Followee, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    describe "#twitter_id" do
      before { create(:followee) } # pre-register to validate uniqueness
      it { should validate_presence_of(:twitter_id) }
      it { should validate_uniqueness_of(:twitter_id).scoped_to(:user_id) }
      it { should validate_numericality_of(:twitter_id).is_greater_than_or_equal_to(0).only_integer }
    end
  end
end

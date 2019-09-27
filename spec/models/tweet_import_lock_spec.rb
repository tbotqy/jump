# frozen_string_literal: true

require "rails_helper"

RSpec.describe TweetImportLock, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    describe "#user_id" do
      before { create(:tweet_import_lock) }
      it { should validate_uniqueness_of(:user_id) }
    end
  end
end

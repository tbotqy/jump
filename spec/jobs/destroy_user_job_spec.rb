# frozen_string_literal: true

require "rails_helper"

RSpec.describe DestroyUserJob, type: :job do
  subject { -> { DestroyUserJob.perform_now(user_id: user_id) } }

  context "fails to identify the user" do
    let!(:user)   { create(:user) }
    let(:user_id) { User.maximum(:id) + 1 }
    it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
  end
  context "succeeds to identify the user" do
    let(:user) { instance_double("User", id: 1) }
    let(:user_id) { user.id }
    before do
      allow(User).to receive(:find).with(user_id).and_return(user)
      allow(user).to receive(:destroy!)
    end
    it "destroys the user with #destroy! method to delete its associations as well" do
      subject.call
      expect(user).to have_received(:destroy!).once
    end
  end
end

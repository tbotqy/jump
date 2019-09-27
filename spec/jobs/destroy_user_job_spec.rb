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
    context "fails to destroy the user" do
      let(:user)    { create(:user) }
      let(:user_id) { user.id }
      before do
        allow(User).to receive(:find).with(user_id).and_return(user)
        allow(user).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)

        create_list(:status, 2, user: user)
        create_list(:status, 2) # another user's statuses
        StatusCount.count_up
      end
      it "doesn't change StatusCount" do
        expect { subject.call rescue nil }.not_to change { StatusCount.current_count }
      end
    end
    context "succeeds to destroy the user" do
      let(:user)    { create(:user) }
      let(:user_id) { user.id }
      let(:user_status_count) { 2 }
      before do
        allow(User).to receive(:find).with(user_id).and_return(user)
        allow(user).to receive(:destroy!)

        create_list(:status, user_status_count, user: user)
        create_list(:status, 2) # another user's statuses
        StatusCount.count_up
      end
      it "destroys the user with #destroy! method to delete its associations as well" do
        subject.call
        expect(user).to have_received(:destroy!).once
      end
      it "decrements StatusCount by the number of destroyed statuses" do
        is_expected.to change { StatusCount.current_count }.by(-1 * user_status_count)
      end
    end
  end
end

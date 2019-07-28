# frozen_string_literal: true

require "rails_helper"

RSpec.describe UpdateUserJob, type: :job do
  subject { described_class.perform_now }
  describe "filtering of target user" do
    context "3 users with no fail log, 4 users with fail log" do
      let!(:user_with_no_fail_log) { create_list(:user, 3) }
      let!(:user_with_fail_log) do
        users = create_list(:user, 4)
        users.each { |user| create(:user_update_fail_log, user: user) }
        users
      end
      describe "only tries to update those users who has no fail log" do
        before do
          user_with_no_fail_log.pluck(:id).each do |user_id|
            allow(UpdateUserService).to receive(:call!).with(user_id: user_id)
          end
        end
        it do
          subject
          user_with_no_fail_log.pluck(:id).each do |user_id|
            expect(UpdateUserService).to have_received(:call!).with(user_id: user_id)
          end
        end

        it do
          subject
          expect(UpdateUserService).to have_received(:call!).exactly(3).times
        end
      end
    end
  end

  describe "fail log creation" do
    context "3 users to succeed to update, 4 users to fail to update" do
      let!(:users_to_succeed) { create_list(:user, 3) }
      let!(:users_to_fail)    { create_list(:user, 4) }
      let(:error_message)     { "Something is wrong with your API request" }

      before do
        users_to_succeed.pluck(:id).each do |user_id|
          allow(UpdateUserService).to receive(:call!).with(user_id: user_id)
        end
        users_to_fail.pluck(:id).each do |user_id|
          allow(UpdateUserService).to receive(:call!).with(user_id: user_id).and_raise(Twitter::Error, error_message)
        end
      end

      it "creates as much fail logs as occurred failures" do
        expect { subject }.to change { UserUpdateFailLog.count }.to(4)
      end

      it "logs the message given from the exception" do
        subject
        expect(UserUpdateFailLog.all).to all(have_attributes(error_message: error_message))
      end

      it "doesn't exit the process" do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe "exception handling" do
    let!(:users) { create_list(:user, 2) }
    context "service class raises a Twitter::Error" do
      before do
        allow(UpdateUserService).to receive(:call!).and_raise(Twitter::Error, "twitter error ocurred")
      end
      describe "the job itself doesn't raise it" do
        it { expect { subject }.not_to raise_error }
      end
    end

    context "service class raises an exception other than a kind of Twitter::Error" do
      let(:error_message) { "non twitter error ocurred" }
      before do
        allow(UpdateUserService).to receive(:call!).and_raise(error_message)
      end
      describe "the job raises it" do
        it { expect { subject }.to raise_error(error_message) }
      end
    end
  end
end

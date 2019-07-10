# frozen_string_literal: true

require "rails_helper"

describe RenewUserFolloweesService do
  describe ".call!" do
    subject { -> { described_class.call!(user_id: user_id) } }

    shared_examples "doesn't renew user's followees" do
      it { expect { subject.call rescue nil }.not_to change { Followee.where(user_id: user_id).pluck(:twitter_id) } }
    end
    shared_examples "doesn't update timestamp" do
      it { expect { subject.call rescue nil }.not_to change { user.reload.friends_updated_at } }
    end

    context "user_id is not given" do
      let!(:user)   { create(:user) }
      let(:user_id) { nil }
      it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
      it_behaves_like "doesn't renew user's followees"
      it_behaves_like "doesn't update timestamp"
    end
    context "user_id is given" do
      context "user doesn't exist" do
        let!(:user)   { create(:user) }
        let(:user_id) { User.maximum(:id) + 1 }
        it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like "doesn't renew user's followees"
        it_behaves_like "doesn't update timestamp"
      end
      context "user exists" do
        context "failed to acquire the latest followees" do
          let!(:user)    { create(:user) }
          let!(:user_id) { user.id }
          before { allow(FetchUserFolloweesService).to receive(:call!).and_raise(RuntimeError) }
          it { is_expected.to raise_error(RuntimeError) }
          it_behaves_like "doesn't renew user's followees"
          it_behaves_like "doesn't update timestamp"
        end
        context "succeeded to acquire the latest followees" do
          context "failed to register them" do
            let!(:user)    { create(:user) }
            let!(:user_id) { user.id }
            before { allow_any_instance_of(described_class).to receive(:fresh_twitter_ids).and_return(["invalid", "values"]) }
            it { is_expected.to raise_error(ActiveRecord::RecordInvalid) }
            it_behaves_like "doesn't renew user's followees"
            it_behaves_like "doesn't update timestamp"
          end
          context "succeeded to register them" do
            context "but failed to log" do
              let(:twitter_ids_before_renew) { [1, 2, 3] }
              let(:twitter_ids_after_renew)  { [4, 5, 6] }
              let(:timestamp_before_renew)   { Time.local(2019, 1, 1).to_i }
              let(:timestamp_after_renew)    { Time.local(2019, 2, 1).to_i }
              let!(:user)   { create(:user, friends_updated_at: timestamp_before_renew) }
              let(:user_id) { user.id }
              before do
                # pre-register user's followee
                twitter_ids_before_renew.each { |twitter_id| create(:followee, user: user, twitter_id: twitter_id) }
                # stub API response
                allow_any_instance_of(described_class).to receive(:fresh_twitter_ids).and_return(twitter_ids_after_renew)
                # assume at when logged to be timestamp_after_renew
                travel_to(Time.at(timestamp_after_renew).utc)
                # get logging to fail
                allow_any_instance_of(User).to receive(:update!).with(friends_updated_at: timestamp_after_renew).and_raise(ActiveRecord::RecordInvalid)
              end
              it { is_expected.to raise_error(ActiveRecord::RecordInvalid) }
              it_behaves_like "doesn't renew user's followees"
              it_behaves_like "doesn't update timestamp"
            end
            context "and succeeded to log as well" do
              shared_examples "updates user's followee" do
                it { is_expected.to change { Followee.where(user_id: user_id).pluck(:twitter_id) }.from(twitter_ids_before_renew).to(twitter_ids_after_renew) }
              end
              shared_examples "updates timestamp" do
                it { is_expected.to change { User.find(user_id).friends_updated_at }.from(timestamp_before_renew).to(timestamp_after_renew) }
              end

              context "user has no followee at initial" do
                let(:twitter_ids_before_renew) { [] }
                let(:twitter_ids_after_renew)  { [4, 5, 6] }
                let(:timestamp_before_renew)   { nil }
                let(:timestamp_after_renew)    { Time.local(2019, 2, 1).to_i }
                let!(:user)   { create(:user, friends_updated_at: timestamp_before_renew) }
                let(:user_id) { user.id }
                before do
                  # stub API response
                  allow_any_instance_of(described_class).to receive(:fresh_twitter_ids).and_return(twitter_ids_after_renew)
                  # assume at when logged to be timestamp_after_renew
                  travel_to(Time.at(timestamp_after_renew).utc)
                end
                it_behaves_like "updates user's followee"
                it_behaves_like "updates timestamp"
              end
              context "user has some followees at initial" do
                let(:twitter_ids_before_renew) { [1, 2, 3] }
                let(:twitter_ids_after_renew)  { [4, 5, 6] }
                let(:timestamp_before_renew)   { Time.local(2019, 1, 1).to_i }
                let(:timestamp_after_renew)    { Time.local(2019, 2, 1).to_i }
                let!(:user)   { create(:user, friends_updated_at: timestamp_before_renew) }
                let(:user_id) { user.id }
                before do
                  # pre-register user's followee
                  twitter_ids_before_renew.each { |twitter_id| create(:followee, user: user, twitter_id: twitter_id) }
                  # stub API response
                  allow_any_instance_of(described_class).to receive(:fresh_twitter_ids).and_return(twitter_ids_after_renew)
                  # assume at when logged to be timestamp_after_renew
                  travel_to(Time.at(timestamp_after_renew).utc)
                end
                it_behaves_like "updates user's followee"
                it_behaves_like "updates timestamp"
              end
            end
          end
        end
      end
    end
  end
end

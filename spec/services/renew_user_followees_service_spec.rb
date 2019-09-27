# frozen_string_literal: true

require "rails_helper"

describe RenewUserFolloweesService do
  describe ".call!" do
    subject { -> { described_class.call!(user_id: user_id) } }

    shared_examples "doesn't renew user's followees" do
      it { expect { subject.call rescue nil }.not_to change { Followee.where(user_id: user_id).pluck(:twitter_id) } }
    end

    context "user_id is not given" do
      let!(:user)   { create(:user) }
      let(:user_id) { nil }
      it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
      it_behaves_like "doesn't renew user's followees"
    end
    context "user_id is given" do
      context "user doesn't exist" do
        let!(:user)   { create(:user) }
        let(:user_id) { User.maximum(:id) + 1 }
        it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
        it_behaves_like "doesn't renew user's followees"
      end
      context "user exists" do
        context "failed to acquire the latest followees" do
          let!(:user)    { create(:user) }
          let!(:user_id) { user.id }
          before { allow_any_instance_of(TwitterClient).to receive(:collect_followee_ids).and_raise(RuntimeError) }
          it { is_expected.to raise_error(RuntimeError) }
          it_behaves_like "doesn't renew user's followees"
        end
        context "succeeded to acquire the latest followees" do
          context "failed to register them" do
            let!(:user)    { create(:user) }
            let!(:user_id) { user.id }
            before { allow_any_instance_of(described_class).to receive(:fresh_twitter_ids).and_return(["invalid", "values"]) }
            it { is_expected.to raise_error(ActiveRecord::RecordInvalid) }
            it_behaves_like "doesn't renew user's followees"
          end
          context "succeeded to register them" do
            shared_examples "updates user's followee" do
              it { is_expected.to change { Followee.where(user_id: user_id).pluck(:twitter_id) }.from(twitter_ids_before_renew).to(twitter_ids_after_renew) }
            end
            context "user has no followee at initial" do
              let(:twitter_ids_before_renew) { [] }
              let(:twitter_ids_after_renew)  { [4, 5, 6] }
              let!(:user)   { create(:user) }
              let(:user_id) { user.id }
              before do
                # stub API response
                allow_any_instance_of(TwitterClient).to receive(:collect_followee_ids).and_return(twitter_ids_after_renew)
              end
              it_behaves_like "updates user's followee"
            end
            context "user has some followees at initial" do
              let(:twitter_ids_before_renew) { [1, 2, 3] }
              let(:twitter_ids_after_renew)  { [4, 5, 6] }
              let!(:user)   { create(:user) }
              let(:user_id) { user.id }
              before do
                # pre-register user's followee
                twitter_ids_before_renew.each { |twitter_id| create(:followee, user: user, twitter_id: twitter_id) }
                # stub API response
                allow_any_instance_of(TwitterClient).to receive(:collect_followee_ids).and_return(twitter_ids_after_renew)
              end
              it_behaves_like "updates user's followee"
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe DestroyUserJob, type: :job do
  subject { -> { DestroyUserJob.perform_now(user_id: user_id_passed_as_param) } }

  shared_examples "makes no change on user's resources" do
    it { expect { subject.call rescue nil }.not_to change { User.exists?(user_id) }                            .from(true) }
    it { expect { subject.call rescue nil }.not_to change { Status.where(user_id: user_id).count }             .from(initial_user_status_count) }
    it { expect { subject.call rescue nil }.not_to change { Entity.where(status_id: user_status_ids).count }   .from(initial_user_entity_count) }
    it { expect { subject.call rescue nil }.not_to change { Followee.where(user_id: user_id).count }           .from(initial_user_followee_count) }
    it { expect { subject.call rescue nil }.not_to change { TweetImportProgress.where(user_id: user_id).count }.from(initial_user_tweet_import_progress_count) }
  end

  # register user and user's belongings
  let!(:user)               { create(:user) }
  let!(:user_id)            { user.id }
  let!(:user_status_ids)    { create_list(:status, 10, user: user).pluck(:id) }
  let!(:user_entity_ids)    { user_status_ids.map { |sid| create_list(:entity, 3, status_id: sid).pluck(:id) }.flatten }
  let!(:user_followee_ids)  { create_list(:followee, 10, user: user).pluck(:id) }
  let!(:user_tweet_import_progress_ids) { create_list(:tweet_import_progress, 3, user: user).pluck(:id) }

  # save initial counts of each belongings
  let!(:initial_user_status_count)   { user_status_ids.count }
  let!(:initial_user_entity_count)   { user_entity_ids.count }
  let!(:initial_user_followee_count) { user_followee_ids.count }
  let!(:initial_user_tweet_import_progress_count) { user_tweet_import_progress_ids.count }

  context "user_id is not given" do
    let(:user_id_passed_as_param) { "" }
    it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
    it_behaves_like "makes no change on user's resources"
  end
  context "user_id is given" do
    context "the user with given id not found" do
      let(:user_id_passed_as_param) { User.maximum(:id) + 1 }
      it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
      it_behaves_like "makes no change on user's resources"
    end
    context "the user with given id found" do
      let(:user_id_passed_as_param) { user_id }
      context "failed to destroy" do
        before { allow_any_instance_of(User).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed) }
        it_behaves_like "makes no change on user's resources"
      end
      context "succeeded to destroy" do
        describe "destroys the user and all of its resources" do
          it { is_expected.to change { User.exists?(user_id) }                           .from(true).to(false) }
          it { is_expected.to change { Status.exists?(user_id: user_id) }                .from(true).to(false) }
          it { is_expected.to change { Entity.where(status_id: user_status_ids).exists? }.from(true).to(false) }
          it { is_expected.to change { Followee.exists?(user_id: user_id) }              .from(true).to(false) }
          it { is_expected.to change { TweetImportProgress.exists?(user_id: user_id) }   .from(true).to(false) }
        end
      end
    end
  end
end

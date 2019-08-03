# frozen_string_literal: true

require "rails_helper"

RSpec.describe MakeAdditionalTweetImportJob, type: :job do
  include TweetMock
  subject { -> { described_class.perform_now(user_id: user_id) } }

  shared_examples "makes no change" do
    describe "registers no tweet" do
      it { expect { subject.call rescue nil }.not_to change { User.find(user_id).statuses.count } }
      it { expect { subject.call rescue nil }.not_to change { User.find(user_id).hashtags.count } }
      it { expect { subject.call rescue nil }.not_to change { User.find(user_id).urls.count } }
      it { expect { subject.call rescue nil }.not_to change { User.find(user_id).media.count } }
    end
    describe "doesn't update ActiveStatusCount" do
      it { expect { subject.call rescue nil }.not_to change { ActiveStatusCount.current_count } }
    end
    describe "doesn't update timestamp" do
      it { expect { subject.call rescue nil }.not_to change { User.find(user_id).statuses_updated_at } }
    end
  end

  shared_examples "the job lock is once acquired" do
    before do
      allow(user).to receive(:create_tweet_import_lock!).and_call_original
      allow(User).to receive(:find).and_return(user)
    end
    it do
      subject.call rescue nil
      expect(user).to have_received(:create_tweet_import_lock!).once
    end
  end

  shared_examples "doesn't leave the job locked" do
    it do
      subject.call rescue nil
      expect(TweetImportLock.exists?(user_id: user_id)).to eq false
    end
  end

  shared_context "user has 2 registered tweets and 10 unregistered tweets" do
    let(:user)    { create(:user, statuses_updated_at: 10) }
    let(:user_id) { user.id }
    let(:unregistered_tweets_count) { 10 }
    before do
      registered_tweet_ids   = [1, 2]
      unregistered_tweet_ids = (3..).first(unregistered_tweets_count)

      # register with "registered_tweet_ids"
      registered_tweet_ids.sort.reverse_each { |tweet_id| create(:status, tweeted_at: tweet_id, tweet_id: tweet_id, user: user) }
      ActiveStatusCount.count_up

      # stub API requests
      tweet_mocks          = unregistered_tweet_ids.sort.reverse.map { |tweet_id| tweet_mock(twitter_account_id: user.twitter_id, id: tweet_id) }
      most_recent_tweet_id = registered_tweet_ids.max
      ## first API request
      allow_any_instance_of(Twitter::REST::Client).to receive(:user_timeline).with(hash_including(since_id: most_recent_tweet_id)).and_return(tweet_mocks)
      ## second (last) API request
      allow_any_instance_of(Twitter::REST::Client).to receive(:user_timeline).with(hash_including(since_id: most_recent_tweet_id, max_id: tweet_mocks.last.id - 1)).and_return([])
    end
  end

  context "fails to identify the user" do
    let!(:user)   { create(:user) }
    let(:user_id) { User.maximum(:id) + 1 }
    it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
  end
  context "succeeds to identify the user" do
    context "the job is locked " do
      let!(:user)   { create(:user) }
      let(:user_id) { user.id }
      before { create(:tweet_import_lock, user: user) }
      it { is_expected.to raise_error("The job has been locked.") }
      it_behaves_like "makes no change"
      it "keeps the job locked" do
        subject.call rescue nil
        expect(TweetImportLock.exists?(user_id: user_id)).to eq true
      end
    end
    context "the job is not locked" do
      context "user has no status yet" do
        let!(:user)   { create(:user) }
        let(:user_id) { user.id }
        it { is_expected.to raise_error("This job is intended to be called for additional import, but user has no status.") }
        it_behaves_like "makes no change"
        it_behaves_like "the job lock is once acquired"
        it_behaves_like "doesn't leave the job locked"
      end
      context "user has some statuses" do
        context "fails to fetch the most recent tweet id of user's statuses" do
          let(:user)    { create(:user) }
          let(:user_id) { user.id }
          before do
            create_list(:status, 2, user: user)
            allow(Status).to receive(:most_recent_tweet_id!).and_raise(ActiveRecord::RecordNotFound)
          end
          it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
          it_behaves_like "makes no change"
          it_behaves_like "the job lock is once acquired"
          it_behaves_like "doesn't leave the job locked"
        end
        context "succeeds to fetch the most recent tweet id of user's statuses" do
          context "fails to fetch tweets via api" do
            let(:user)    { create(:user) }
            let(:user_id) { user.id }
            before do
              registered_tweet_ids = create_list(:status, 2, user: user).pluck(:tweet_id)
              most_recent_tweet_id = registered_tweet_ids.max
              allow_any_instance_of(Twitter::REST::Client).to receive(:user_timeline).with(hash_including(since_id: most_recent_tweet_id)).and_raise(Twitter::Error)
            end
            it { is_expected.to raise_error(Twitter::Error) }
            it_behaves_like "makes no change"
            it_behaves_like "the job lock is once acquired"
            it_behaves_like "doesn't leave the job locked"
          end
          context "succeeds to fetch tweets via api" do
            context "fails to register fetched tweets" do
              include_context "user has 2 registered tweets and 10 unregistered tweets"
              before { allow(RegisterTweetService).to receive(:call!).and_raise(ActiveRecord::RecordInvalid) }
              it { is_expected.to raise_error(ActiveRecord::RecordInvalid) }
              it_behaves_like "makes no change"
              it_behaves_like "the job lock is once acquired"
              it_behaves_like "doesn't leave the job locked"
            end
            context "succeeds to register fetched tweets" do
              context "fails to update timestamp" do
                include_context "user has 2 registered tweets and 10 unregistered tweets"
                before do
                  travel_to(Time.current)
                  allow_any_instance_of(User).to receive(:update!).with(statuses_updated_at: Time.current.to_i).and_raise(ActiveRecord::RecordInvalid)
                end
                after { travel_back }
                it { is_expected.to raise_error(ActiveRecord::RecordInvalid) }
                it_behaves_like "makes no change"
                it_behaves_like "the job lock is once acquired"
                it_behaves_like "doesn't leave the job locked"
              end
              context "succeeds to update timestamp" do
                context "fails to increment ActiveStatusCount" do
                  include_context "user has 2 registered tweets and 10 unregistered tweets"
                  before { allow(ActiveStatusCount).to receive(:increment_by).and_raise(Redis::CannotConnectError) }
                  it { is_expected.to raise_error(Redis::CannotConnectError) }
                  it_behaves_like "makes no change"
                  it_behaves_like "the job lock is once acquired"
                  it_behaves_like "doesn't leave the job locked"
                end
                context "succeeds to increment ActiveStatusCount" do
                  include_context "user has 2 registered tweets and 10 unregistered tweets"
                  it { is_expected.not_to raise_error }
                  describe "registers tweets" do
                    it { is_expected.to change { User.find(user_id).statuses.count }.by(unregistered_tweets_count) }
                    it { is_expected.to change { User.find(user_id).hashtags.count } }
                    it { is_expected.to change { User.find(user_id).urls.count } }
                    it { is_expected.to change { User.find(user_id).media.count } }
                  end
                  it "increments ActiveStatusCount by the number of tweets" do
                    is_expected.to change { ActiveStatusCount.current_count }.by(unregistered_tweets_count)
                  end
                  describe "updates timestamp" do
                    before { travel_to(Time.current) }
                    after  { travel_back }
                    it { is_expected.to change { User.find(user_id).statuses_updated_at }.to(Time.current.to_i) }
                  end
                  it_behaves_like "the job lock is once acquired"
                  it_behaves_like "doesn't leave the job locked"
                end
              end
            end
          end
        end
      end
    end
  end
end

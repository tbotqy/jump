# frozen_string_literal: true

require "rails_helper"

RSpec.describe MakeInitialTweetImportJob, type: :job do
  include TweetMock
  subject { -> { described_class.perform_now(user_id: user_id) } }

  shared_examples "makes no change" do
    describe "registers no tweet" do
      it { expect { subject.call rescue nil }.not_to change { User.find(user_id).statuses.count } }
      it { expect { subject.call rescue nil }.not_to change { User.find(user_id).hashtags.count } }
      it { expect { subject.call rescue nil }.not_to change { User.find(user_id).urls.count } }
      it { expect { subject.call rescue nil }.not_to change { User.find(user_id).media.count } }
    end
    describe "doesn't update StatusCount" do
      it { expect { subject.call rescue nil }.not_to change { StatusCount.current_count } }
    end
    describe "doesn't update timestamp" do
      it { expect { subject.call rescue nil }.not_to change { User.find(user_id).statuses_updated_at }.from(nil) }
    end
  end
  shared_examples "leaves no tweet_import_progress related to the user" do
    it { expect { subject.call rescue nil }.not_to change { User.find(user_id).tweet_import_progress.present? }.from(false) }
  end
  shared_examples "leaves no tweet_import_progress" do
    it { expect { subject.call rescue nil }.not_to change { TweetImportProgress.count } }
  end

  shared_context "user has 10 tweets on twitter" do
    let(:user)        { create(:user, statuses_updated_at: nil) }
    let(:user_id)     { user.id }
    let(:tweet_mocks) { (101..110).to_a.reverse.map { |tweet_id| tweet_mock(twitter_account_id: user.twitter_id, id: tweet_id) } }
    before do
      # first API request
      allow_any_instance_of(Twitter::REST::Client).to receive(:user_timeline).with(anything).and_return(tweet_mocks)
      # second (last) API request
      allow_any_instance_of(Twitter::REST::Client).to receive(:user_timeline).with(hash_including(max_id: tweet_mocks.last.id - 1)).and_return([])
    end
  end

  context "fails to identify the user" do
    let!(:user)   { create(:user) }
    let(:user_id) { User.maximum(:id) + 1 }
    it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
    it_behaves_like "leaves no tweet_import_progress"
  end
  context "succeeds to identify the user" do
    context "user already has some statuses" do
      let(:user)    { create(:user) }
      let(:user_id) { user.id }
      before { create_list(:status, 2, user: user) }
      it { is_expected.to raise_error("This job is intended to be called for initial import, but user already has some statuses.") }
      it_behaves_like "makes no change"
      it_behaves_like "leaves no tweet_import_progress"
    end
    context "user has no status yet" do
      context "fails to create a tweet_import_progress" do
        let(:user)    { create(:user) }
        let(:user_id) { user.id }
        before { allow_any_instance_of(described_class).to receive(:initialize_progress!).and_raise(ActiveRecord::RecordInvalid) }
        it { is_expected.to raise_error(ActiveRecord::RecordInvalid) }
        it_behaves_like "makes no change"
        it_behaves_like "leaves no tweet_import_progress"
      end
      context "succeeds to create a tweet_import_progress" do
        context "fails to fetch tweets via api" do
          let(:user)    { create(:user) }
          let(:user_id) { user.id }
          before { allow_any_instance_of(Twitter::REST::Client).to receive(:user_timeline).and_raise(Twitter::Error) }
          it { is_expected.to raise_error(Twitter::Error) }
          it_behaves_like "makes no change"
          it_behaves_like "leaves no tweet_import_progress related to the user"
        end
        context "succeeds to fetch tweets via api" do
          context "fails to register fetched tweets" do
            include_context "user has 10 tweets on twitter"
            before { allow(RegisterTweetService).to receive(:call!).and_raise(ActiveRecord::RecordInvalid) }
            it { is_expected.to raise_error(ActiveRecord::RecordInvalid) }
            it_behaves_like "makes no change"
            it_behaves_like "leaves no tweet_import_progress related to the user"
          end
          context "succeeds to register fetched tweets" do
            context "fails to increment progress" do
              include_context "user has 10 tweets on twitter"
              before { allow_any_instance_of(TweetImportProgress).to receive(:increment_by).and_raise(Redis::CannotConnectError) }
              it { is_expected.to raise_error(Redis::CannotConnectError) }
              it_behaves_like "makes no change"
              it_behaves_like "leaves no tweet_import_progress related to the user"
            end
            context "succeeds to increment progress" do
              context "fails to update timestamp" do
                include_context "user has 10 tweets on twitter"
                before { allow_any_instance_of(User).to receive(:update!).with(statuses_updated_at: anything).and_raise(ActiveRecord::RecordInvalid) }
                it { is_expected.to raise_error(ActiveRecord::RecordInvalid) }
                it_behaves_like "makes no change"
                it_behaves_like "leaves no tweet_import_progress related to the user"
              end
              context "succeeds to update timestamp" do
                context "fails to mark progress as finished" do
                  include_context "user has 10 tweets on twitter"
                  before { allow_any_instance_of(TweetImportProgress).to receive(:mark_as_finished!).and_raise(ActiveRecord::RecordInvalid) }
                  it { is_expected.to raise_error(ActiveRecord::RecordInvalid) }
                  it_behaves_like "makes no change"
                  it_behaves_like "leaves no tweet_import_progress related to the user"
                end
                context "succeeds to mark progress as finished" do
                  context "fails to increment StatusCount" do
                    include_context "user has 10 tweets on twitter"
                    before { allow(StatusCount).to receive(:increment_by).and_raise(Redis::CannotConnectError) }
                    it { is_expected.to raise_error(Redis::CannotConnectError) }
                    it_behaves_like "makes no change"
                    it_behaves_like "leaves no tweet_import_progress related to the user"
                  end
                  context "succeeds to mark progress as finished" do
                    shared_examples "examples" do
                      it { is_expected.not_to raise_error }
                      describe "registers tweets" do
                        it { is_expected.to change { User.find(user_id).statuses.count }.to(tweet_mocks.count) }
                        it { is_expected.to change { User.find(user_id).hashtags.count } }
                        it { is_expected.to change { User.find(user_id).urls.count } }
                        it { is_expected.to change { User.find(user_id).media.count } }
                      end
                      it "leaves a tweet_import_progress with an expected state" do
                        subject.call
                        tweet_import_progress = TweetImportProgress.find_by!(user: user)
                        expect(tweet_import_progress).to have_attributes(
                          user_id:  user.id,
                          finished: true
                        )
                        expect(tweet_import_progress.current_count.value).to eq tweet_mocks.count
                        expect(tweet_import_progress.last_tweet_id.value).to eq tweet_mocks.last.id.to_s
                      end
                      it "increments StatusCount by the number of tweets" do
                        is_expected.to change { StatusCount.current_count }.by(tweet_mocks.count)
                      end
                      describe "updates timestamp" do
                        before { travel_to(Time.current) }
                        after  { travel_back }
                        it { is_expected.to change { User.find(user_id).statuses_updated_at }.from(nil).to(Time.current.to_i) }
                      end
                    end

                    include_context "user has 10 tweets on twitter" do
                      context "user has already had a tweet_import_progress before kicking this job" do
                        let(:user) { create(:tweet_import_progress).user }
                        include_examples "examples"
                      end
                      context "user has had no tweet_import_progress before kicking this job" do
                        let(:user) { create(:user) }
                        include_examples "examples"
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe TwitterClient do
  include TweetMock

  describe "#collect_tweets_in_batches" do
    let(:user)     { create(:user) }
    let(:instance) { described_class.new(access_token: user.access_token, access_token_secret: user.access_token_secret) }
    subject { instance.collect_tweets_in_batches(after_id: after_id, before_id: before_id) }

    def api_params(since_id: nil, max_id: nil)
      {
        since_id:    since_id,
        max_id:      max_id,
        include_rts: true,
        count:       200
      }.compact
    end

    context "user has no tweet on twitter" do
      let(:user_rest_client) { instance_double("Twitter::REST::Client") }
      before do
        # emulate API request to return a blank array
        max_id = before_id.present? ? before_id - 1 : nil
        allow(user_rest_client).to receive(:user_timeline).with(
          api_params(since_id: after_id, max_id: max_id)
        ).and_return([])

        allow_any_instance_of(described_class).to receive(:user_rest_client).and_return(user_rest_client)
      end

      shared_examples "behaviors when no tweet found" do
        describe "builds API request appropriately" do
          before { subject }
          it "calls API as much times as expected" do
            expect(user_rest_client).to have_received(:user_timeline).once
          end
          it "builds the 1st API request correctly" do
            first_max_id = before_id.present? ? before_id - 1 : nil
            expect(user_rest_client).to have_received(:user_timeline).with(
              api_params(since_id: after_id, max_id: first_max_id)
            ).once
          end
        end
        describe "handles with block" do
          context "no block is given" do
            it { expect { subject }.not_to raise_error }
          end
          context "block is given" do
            it "doesn't yield given block" do
              expect do |b|
                instance.collect_tweets_in_batches(after_id: after_id, before_id: before_id, &b)
              end.not_to yield_control
            end
          end
        end
        describe "returns a blank collection" do
          it { is_expected.to eq [] }
        end
      end

      context "no search condition is specified" do
        let(:after_id)  { nil }
        let(:before_id) { nil }
        include_examples "behaviors when no tweet found"
      end
      context "only after_id is specified" do
        let(:after_id)  { 10 }
        let(:before_id) { nil }
        include_examples "behaviors when no tweet found"
      end
      context "only before_id is specified" do
        let(:after_id)  { nil }
        let(:before_id) { 20 }
        include_examples "behaviors when no tweet found"
      end
      context "both after_id and before_id is specified" do
        let(:after_id)  { 10 }
        let(:before_id) { 20 }
        include_examples "behaviors when no tweet found"
      end
    end

    context "user has some tweets on twitter" do
      describe "recursive collection" do
        shared_context "3 API requests are to be made as a result" do
          let(:user_rest_client) { instance_double("Twitter::REST::Client") }
          let(:stubbed_tweet_id_range) { 101..104 }
          let(:first_responses)  { stubbed_tweet_id_range.last(2).to_a.reverse.map { |tweet_id| tweet_mock(twitter_account_id: user.twitter_id, id: tweet_id) } }
          let(:second_responses) { stubbed_tweet_id_range.first(2).to_a.reverse.map { |tweet_id| tweet_mock(twitter_account_id: user.twitter_id, id: tweet_id) } }
          let(:third_responses)  { [] }
          before do
            # emulate the 1st API request
            first_max_id = before_id.present? ? before_id - 1 : nil
            allow(user_rest_client).to receive(:user_timeline).with(
              api_params(since_id: after_id, max_id: first_max_id)
            ).and_return(first_responses)

            # emulate the 2nd API request
            allow(user_rest_client).to receive(:user_timeline).with(
              api_params(since_id: after_id, max_id: first_responses.last.id - 1)
            ).and_return(second_responses)

            # emulate the 3rd(last) API request
            allow(user_rest_client).to receive(:user_timeline).with(
              api_params(since_id: after_id, max_id: second_responses.last.id - 1)
            ).and_return(third_responses)

            allow_any_instance_of(described_class).to receive(:user_rest_client).and_return(user_rest_client)
          end
        end

        shared_examples "behaviors when user has some tweets" do
          describe "builds API requests appropriately" do
            before { subject }
            it "calls API as much times as expected" do
              expect(user_rest_client).to have_received(:user_timeline).exactly(3).times
            end
            it "builds the 1st API request correctly" do
              first_max_id = before_id.present? ? before_id - 1 : nil
              expect(user_rest_client).to have_received(:user_timeline).with(
                api_params(since_id: after_id, max_id: first_max_id)
              ).once
            end
            it "builds the 2nd API request correctly" do
              subject
              expect(user_rest_client).to have_received(:user_timeline).with(
                api_params(since_id: after_id, max_id: first_responses.last.id - 1)
              ).once
            end
            it "builds the 3rd(last) API request correctly" do
              subject
              expect(user_rest_client).to have_received(:user_timeline).with(
                api_params(since_id: after_id, max_id: second_responses.last.id - 1)
              ).once
            end
          end
          describe "handles with block" do
            context "no block is given" do
              it { expect { subject }.not_to raise_error }
            end
            context "block is given" do
              it "only yields if the API response is not blank?" do
                number_of_responses_not_blank = 2 # expecting "3 API requests are to be made as a result" is applied as the context
                expect do |b|
                  instance.collect_tweets_in_batches(after_id: after_id, before_id: before_id, &b)
                end.to yield_control.exactly(number_of_responses_not_blank).times
              end
              it "yields with API responses taken as argument" do
                expect do |b|
                  instance.collect_tweets_in_batches(after_id: after_id, before_id: before_id, &b)
                end.to yield_successive_args(first_responses, second_responses)
              end
            end
          end
          describe "returns collections" do
            it { is_expected.to contain_exactly(*first_responses, *second_responses) }
          end
        end

        include_context "3 API requests are to be made as a result" do
          context "no search condition is specified" do
            let(:after_id)  { nil }
            let(:before_id) { nil }
            include_examples "behaviors when user has some tweets"
          end
          context "only after_id is specified" do
            let(:after_id)  { stubbed_tweet_id_range.first - 1 }
            let(:before_id) { nil }
            include_examples "behaviors when user has some tweets"
          end
          context "only before_id is specified" do
            let(:after_id)  { nil }
            let(:before_id) { stubbed_tweet_id_range.last + 1 }
            include_examples "behaviors when user has some tweets"
          end
          context "both after_id and before_id is specified" do
            let(:after_id)  { stubbed_tweet_id_range.first - 1 }
            let(:before_id) { stubbed_tweet_id_range.last + 1 }
            include_examples "behaviors when user has some tweets"
          end
        end
      end
    end
  end

  describe "#collect_followee_ids" do
    let(:user) { create(:user) }
    subject { described_class.new(access_token: user.access_token, access_token_secret: user.access_token_secret).collect_followee_ids }
    let(:user_rest_client) { instance_double("Twitter::REST::Client") }
    let(:friend_api_initial_cursor)  { -1 }
    let(:friend_api_terminal_cursor) { 0 }
    context "user has no followee" do
      before do
        allow(user_rest_client).to receive_message_chain(:friend_ids).with(cursor: friend_api_initial_cursor).and_return(
          instance_double("Twitter::Cursor", attrs: { ids: [], next_cursor: friend_api_terminal_cursor })
        )
        allow_any_instance_of(described_class).to receive(:user_rest_client).and_return(user_rest_client)
      end
      it "it builds the 1st API request correctly" do
        subject
        expect(user_rest_client).to have_received(:friend_ids).with(cursor: friend_api_initial_cursor).once
      end
      it "doesn't make the 2nd API request" do
        subject
        expect(user_rest_client).to have_received(:friend_ids).with(anything).once
      end
      it { is_expected.to eq [] }
    end
    context "user has some followees" do
      describe "recursive collection" do
        let(:first_responses)  { [1, 2, 3] }
        let(:second_responses) { [4, 5, 6] }
        before do
          # emulate the 1st API request
          allow(user_rest_client).to receive_message_chain(:friend_ids).with(cursor: friend_api_initial_cursor).and_return(
            instance_double("Twitter::Cursor", attrs: { ids: first_responses, next_cursor: first_responses.last + 1 })
          )
          # emulate the 2nd(last) API request
          cursor = first_responses.last + 1
          allow(user_rest_client).to receive_message_chain(:friend_ids).with(cursor: cursor).and_return(
            instance_double("Twitter::Cursor", attrs: { ids: second_responses, next_cursor: friend_api_terminal_cursor })
          )
          allow_any_instance_of(described_class).to receive(:user_rest_client).and_return(user_rest_client)
        end
        it "it builds the 1st API request correctly" do
          subject
          expect(user_rest_client).to have_received(:friend_ids).with(cursor: friend_api_initial_cursor).once
        end
        it "it builds the 2nd API request correctly" do
          subject
          expect(user_rest_client).to have_received(:friend_ids).with(cursor: first_responses.last + 1).once
        end
        it "doesn't make the 3rd API request" do
          subject
          expect(user_rest_client).to have_received(:friend_ids).with(anything).twice
        end
        it { is_expected.to contain_exactly(*first_responses, *second_responses) }
      end
    end
  end
end

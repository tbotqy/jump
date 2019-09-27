# frozen_string_literal: true

require "rails_helper"

include TweetMock

describe RegisterTweetService do
  describe ".call!" do
    subject { -> { described_class.call!(tweet: tweet) } }

    shared_examples "shouldn't create any record" do
      it { expect { subject.call rescue nil }.not_to change { Status.count } }
      it { expect { subject.call rescue nil }.not_to change { Hashtag.count } }
      it { expect { subject.call rescue nil }.not_to change { Url.count } }
      it { expect { subject.call rescue nil }.not_to change { Medium.count } }
    end

    shared_examples "should raise RecordInvalid error" do |model|
      message = model.present? ? "Validation failed: #{model.name.pluralize} is invalid" : nil
      it { is_expected.to raise_error(ActiveRecord::RecordInvalid, message) }
    end

    shared_examples "should not create any hashtags" do
      it { is_expected.not_to change { User.find(user.id).hashtags.count } }
    end

    shared_examples "should not create any urls" do
      it { is_expected.not_to change { User.find(user.id).urls.count } }
    end

    shared_examples "should not create any media" do
      it { is_expected.not_to change { User.find(user.id).media.count } }
    end

    context "fails to identify the user with given tweet" do
      let!(:user) { create(:user) }
      let(:tweet) { tweet_mock(twitter_account_id: user.twitter_id + 1) }
      it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
      it_behaves_like "shouldn't create any record"
    end
    context "succeeds to identify the user with given tweet" do
      context "tweet is a retweet" do
        shared_examples "should create a status using retweeted tweet's attributes" do
          it { is_expected.to change { User.find(user.id).statuses.count }.by(1) }
          it do
            subject.call
            tweet_id        = tweet.id
            tweeted_at      = tweet.created_at
            tweeted_at_int  = tweeted_at.to_i
            retweeted_tweet = tweet.retweeted_tweet
            expect(Status.find_by!(tweet_id: tweet.id)).to have_attributes(
              tweet_id:                tweet_id,
              tweet_id_reversed:       -1 * tweet_id,
              in_reply_to_tweet_id:    tweet.in_reply_to_tweet_id,
              in_reply_to_twitter_id:  tweet.in_reply_to_user_id,
              in_reply_to_screen_name: tweet.in_reply_to_screen_name,
              place_full_name:         tweet.place.full_name,
              retweet_count:           tweet.retweet_count,
              tweeted_at:              tweeted_at_int,
              tweeted_at_reversed:     -1 * tweeted_at_int,
              tweeted_on:              tweeted_at.in_time_zone.beginning_of_day,
              source:                  tweet.source,
              text:                    tweet.attrs[:full_text],
              possibly_sensitive:      tweet.possibly_sensitive?,
              private_flag:            tweet.user.protected?,
              is_retweet:              true,
              rt_name:                 retweeted_tweet.user.name,
              rt_screen_name:          retweeted_tweet.user.screen_name,
              rt_avatar_url:           retweeted_tweet.user.profile_image_url_https.to_s,
              rt_text:                 retweeted_tweet.attrs[:full_text],
              rt_source:               retweeted_tweet.source,
              rt_created_at:           retweeted_tweet.created_at.to_i
            )
          end
        end
        shared_examples "should create hashtags using retweeted tweet's hashtags" do
          it { is_expected.to change { User.find(user.id).hashtags.count }.by(tweet.retweeted_tweet.hashtags.count) }
          it do
            subject.call
            testing_attrs = %i|text index_f index_l|
            expect(Status.find_by!(tweet_id: tweet.id).hashtags.pluck(*testing_attrs)).to contain_exactly(
              *tweet.retweeted_tweet.hashtags.map do |retweeted_tweet_hashtag|
                [
                  retweeted_tweet_hashtag.text,
                  retweeted_tweet_hashtag.indices.first,
                  retweeted_tweet_hashtag.indices.last
                ]
              end
            )
          end
        end
        shared_examples "should create urls using retweeted tweet's urls" do
          it { is_expected.to change { User.find(user.id).urls.count }.by(tweet.retweeted_tweet.urls.count) }
          it do
            subject.call
            testing_attrs = %i|url display_url index_f index_l|
            expect(Status.find_by!(tweet_id: tweet.id).urls.pluck(*testing_attrs)).to contain_exactly(
              *tweet.retweeted_tweet.urls.map do |retweeted_tweet_url|
                [
                  retweeted_tweet_url.url,
                  retweeted_tweet_url.display_url,
                  retweeted_tweet_url.indices.first,
                  retweeted_tweet_url.indices.last
                ]
              end
            )
          end
        end
        shared_examples "should create media using retweeted tweet's media" do
          it { is_expected.to change { User.find(user.id).media.count }.by(tweet.retweeted_tweet.media.count) }
          it do
            subject.call
            testing_attrs = %i|url direct_url display_url index_f index_l|
            expect(Status.find_by!(tweet_id: tweet.id).media.pluck(*testing_attrs)).to contain_exactly(
              *tweet.retweeted_tweet.media.map do |retweeted_tweet_medium|
                [
                  retweeted_tweet_medium.url,
                  retweeted_tweet_medium.media_url,
                  retweeted_tweet_medium.display_url,
                  retweeted_tweet_medium.indices.first,
                  retweeted_tweet_medium.indices.last
                ]
              end
            )
          end
        end
        context "fails to create a status" do
          let!(:user) { create(:user) }
          let(:tweet) { retweeting_tweet_mock(twitter_account_id: user.twitter_id, retweeted_tweet: incomplete_retweeted_tweet_mock) }
          it_behaves_like "should raise RecordInvalid error"
          it_behaves_like "shouldn't create any record"
        end
        context "succeeds to create a status" do
          context "retweeted tweet has no entity" do
            let!(:user) { create(:user) }
            let(:tweet) { retweeting_tweet_mock(twitter_account_id: user.twitter_id, retweeted_tweet: retweeted_tweet_mock(hashtags: [], urls: [], media: [])) }
            it { is_expected.not_to raise_error }
            it_behaves_like "should create a status using retweeted tweet's attributes"
            describe "shouldn't create any kind of entities" do
              it_behaves_like "should not create any hashtags"
              it_behaves_like "should not create any urls"
              it_behaves_like "should not create any media"
            end
          end
          context "retweeted tweet has some entities" do
            context "fails to create some of retweeted tweet's entities" do
              context "fails to create hashtags" do
                let!(:user) { create(:user) }
                let(:tweet) { retweeting_tweet_mock(twitter_account_id: user.twitter_id, retweeted_tweet: retweeted_tweet_mock(hashtags: [incomplete_hashtag_mock])) }
                it_behaves_like "should raise RecordInvalid error", Hashtag
                it_behaves_like "shouldn't create any record"
              end
              context "fails to create urls" do
                let!(:user) { create(:user) }
                let(:tweet) { retweeting_tweet_mock(twitter_account_id: user.twitter_id, retweeted_tweet: retweeted_tweet_mock(urls: [incomplete_url_mock])) }
                it_behaves_like "should raise RecordInvalid error", Url
                it_behaves_like "shouldn't create any record"
              end
              context "fails to create media" do
                let!(:user) { create(:user) }
                let(:tweet) { retweeting_tweet_mock(twitter_account_id: user.twitter_id, retweeted_tweet: retweeted_tweet_mock(media: [incomplete_media_mock])) }
                it_behaves_like "should raise RecordInvalid error", Medium
                it_behaves_like "shouldn't create any record"
              end
            end
            context "no failure in creating hashtags" do
              context "retweeted tweet has not all the kinds of entities" do
                context "has no hashtags" do
                  let!(:user) { create(:user) }
                  let(:tweet) { retweeting_tweet_mock(twitter_account_id: user.twitter_id, retweeted_tweet: retweeted_tweet_mock(hashtags: [])) }
                  it_behaves_like "should create a status using retweeted tweet's attributes"
                  describe "should create entities other than hashtags" do
                    it_behaves_like "should not create any hashtags"
                    it_behaves_like "should create urls using retweeted tweet's urls"
                    it_behaves_like "should create media using retweeted tweet's media"
                  end
                end
                context "has no urls" do
                  let!(:user) { create(:user) }
                  let(:tweet) { retweeting_tweet_mock(twitter_account_id: user.twitter_id, retweeted_tweet: retweeted_tweet_mock(urls: [])) }
                  it_behaves_like "should create a status using retweeted tweet's attributes"
                  describe "should create entities other than urls" do
                    it_behaves_like "should create hashtags using retweeted tweet's hashtags"
                    it_behaves_like "should not create any urls"
                    it_behaves_like "should create media using retweeted tweet's media"
                  end
                end
                context "has no media" do
                  let!(:user) { create(:user) }
                  let(:tweet) { retweeting_tweet_mock(twitter_account_id: user.twitter_id, retweeted_tweet: retweeted_tweet_mock(media: [])) }
                  it_behaves_like "should create a status using retweeted tweet's attributes"
                  describe "should create entities other than media" do
                    it_behaves_like "should create hashtags using retweeted tweet's hashtags"
                    it_behaves_like "should create urls using retweeted tweet's urls"
                    it_behaves_like "should not create any media"
                  end
                end
              end

              context "tweet has all the kinds of entities" do
                let!(:user) { create(:user) }
                let(:tweet) { retweeting_tweet_mock(twitter_account_id: user.twitter_id) }
                it_behaves_like "should create a status using retweeted tweet's attributes"
                it_behaves_like "should create hashtags using retweeted tweet's hashtags"
                it_behaves_like "should create urls using retweeted tweet's urls"
                it_behaves_like "should create media using retweeted tweet's media"
              end
            end
          end
        end
      end

      context "tweet is not a retweet (a normal tweet)" do
        shared_examples "should create a status appropriately" do
          it { is_expected.to change { User.find(user.id).statuses.count }.by(1) }
          it do
            subject.call
            tweet_id        = tweet.id
            tweeted_at      = tweet.created_at
            tweeted_at_int  = tweeted_at.to_i
            expect(Status.find_by!(tweet_id: tweet.id)).to have_attributes(
              tweet_id:                tweet_id,
              tweet_id_reversed:       -1 * tweet_id,
              in_reply_to_tweet_id:    tweet.in_reply_to_tweet_id,
              in_reply_to_twitter_id:  tweet.in_reply_to_user_id,
              in_reply_to_screen_name: tweet.in_reply_to_screen_name,
              place_full_name:         tweet.place.full_name,
              retweet_count:           tweet.retweet_count,
              tweeted_at:              tweeted_at_int,
              tweeted_at_reversed:     -1 * tweeted_at_int,
              tweeted_on:              tweeted_at.in_time_zone.beginning_of_day,
              source:                  tweet.source,
              text:                    tweet.attrs[:full_text],
              possibly_sensitive:      tweet.possibly_sensitive?,
              private_flag:            tweet.user.protected?,
              is_retweet:              false,
              rt_name:                 nil,
              rt_screen_name:          nil,
              rt_avatar_url:           nil,
              rt_text:                 nil,
              rt_source:               nil,
              rt_created_at:           nil
            )
          end
        end
        shared_examples "should create hashtags using tweet's hashtags" do
          it { is_expected.to change { User.find(user.id).hashtags.count }.by(tweet.hashtags.count) }
          it do
            subject.call
            testing_attrs = %i|text index_f index_l|
            expect(Status.find_by!(tweet_id: tweet.id).hashtags.pluck(*testing_attrs)).to contain_exactly(
              *tweet.hashtags.map do |tweet_hashtag|
                [
                  tweet_hashtag.text,
                  tweet_hashtag.indices.first,
                  tweet_hashtag.indices.last
                ]
              end
            )
          end
        end
        shared_examples "should create urls using tweet's urls" do
          it { is_expected.to change { User.find(user.id).urls.count }.by(tweet.urls.count) }
          it do
            subject.call
            testing_attrs = %i|url display_url index_f index_l|
            expect(Status.find_by!(tweet_id: tweet.id).urls.pluck(*testing_attrs)).to contain_exactly(
              *tweet.urls.map do |tweet_url|
                [
                  tweet_url.url,
                  tweet_url.display_url,
                  tweet_url.indices.first,
                  tweet_url.indices.last
                ]
              end
            )
          end
        end
        shared_examples "should create media using tweet's media" do
          it { is_expected.to change { User.find(user.id).media.count }.by(tweet.media.count) }
          it do
            subject.call
            testing_attrs = %i|url direct_url display_url index_f index_l|
            expect(Status.find_by!(tweet_id: tweet.id).media.pluck(*testing_attrs)).to contain_exactly(
              *tweet.media.map do |tweet_medium|
                [
                  tweet_medium.url,
                  tweet_medium.media_url,
                  tweet_medium.display_url,
                  tweet_medium.indices.first,
                  tweet_medium.indices.last
                ]
              end
            )
          end
        end

        context "fails to create a status" do
          let!(:user) { create(:user) }
          let(:tweet) { tweet_mock(twitter_account_id: user.twitter_id, attrs: { full_text: "" }) }
          it_behaves_like "should raise RecordInvalid error"
          it_behaves_like "shouldn't create any record"
        end
        context "succeeds to create a status" do
          context "tweet has no entity" do
            let!(:user) { create(:user) }
            let(:tweet) { tweet_mock(twitter_account_id: user.twitter_id, hashtags: [], urls: [], media: []) }
            it { is_expected.not_to raise_error }
            it_behaves_like "should create a status appropriately"
            describe "shouldn't create any kind of entities" do
              it_behaves_like "should not create any hashtags"
              it_behaves_like "should not create any urls"
              it_behaves_like "should not create any media"
            end
          end
          context "tweet has some entities" do
            context "fails to create some of tweet's entities" do
              context "fails to create hashtags" do
                let!(:user) { create(:user) }
                let(:tweet) { tweet_mock(twitter_account_id: user.twitter_id, hashtags: [incomplete_hashtag_mock]) }
                it_behaves_like "should raise RecordInvalid error", Hashtag
                it_behaves_like "shouldn't create any record"
              end
              context "fails to create urls" do
                let!(:user) { create(:user) }
                let(:tweet) { tweet_mock(twitter_account_id: user.twitter_id, urls: [incomplete_url_mock]) }
                it_behaves_like "should raise RecordInvalid error", Url
                it_behaves_like "shouldn't create any record"
              end
              context "fails to create media" do
                let!(:user) { create(:user) }
                let(:tweet) { tweet_mock(twitter_account_id: user.twitter_id, media: [incomplete_media_mock]) }
                it_behaves_like "should raise RecordInvalid error", Medium
                it_behaves_like "shouldn't create any record"
              end
            end
            context "no failure in creating hashtags" do
              context "tweet has not all the kinds of entities" do
                context "has no hashtags" do
                  let!(:user) { create(:user) }
                  let(:tweet) { tweet_mock(twitter_account_id: user.twitter_id, hashtags: []) }
                  it_behaves_like "should create a status appropriately"
                  describe "should create entities other than hashtags" do
                    it_behaves_like "should not create any hashtags"
                    it_behaves_like "should create urls using tweet's urls"
                    it_behaves_like "should create media using tweet's media"
                  end
                end
                context "has no urls" do
                  let!(:user) { create(:user) }
                  let(:tweet) { tweet_mock(twitter_account_id: user.twitter_id, urls: []) }
                  it_behaves_like "should create a status appropriately"
                  describe "should create entities other than urls" do
                    it_behaves_like "should create hashtags using tweet's hashtags"
                    it_behaves_like "should not create any urls"
                    it_behaves_like "should create media using tweet's media"
                  end
                end
                context "has no media" do
                  let!(:user) { create(:user) }
                  let(:tweet) { tweet_mock(twitter_account_id: user.twitter_id, media: []) }
                  it_behaves_like "should create a status appropriately"
                  describe "should create entities other than media" do
                    it_behaves_like "should create hashtags using tweet's hashtags"
                    it_behaves_like "should create urls using tweet's urls"
                    it_behaves_like "should not create any media"
                  end
                end
              end

              context "tweet has all the kinds of entities" do
                let!(:user) { create(:user) }
                let(:tweet) { tweet_mock(twitter_account_id: user.twitter_id) }
                it_behaves_like "should create a status appropriately"
                it_behaves_like "should create hashtags using tweet's hashtags"
                it_behaves_like "should create urls using tweet's urls"
                it_behaves_like "should create media using tweet's media"
              end
            end
          end
        end
      end
    end
  end
end

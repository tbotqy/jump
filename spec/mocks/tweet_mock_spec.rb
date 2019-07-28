# frozen_string_literal: true

require "rails_helper"

describe TweetMock do
  include TweetMock

  describe "tweet_mock" do
    subject { tweet_mock(twitter_account_id: twitter_account_id, **attrs) }

    before { travel_to(Time.now.utc) }
    after  { travel_back }

    describe "default state" do
      let(:twitter_account_id) { 8888 }
      let(:attrs) { {} }
      describe "it has default values" do
        it do
          is_expected.to have_attributes(
            id:                      100,
            in_reply_to_tweet_id:    1,
            in_reply_to_user_id:     2,
            in_reply_to_screen_name: "in_reply_to_screen_name",
            retweet_count:           10,
            created_at:              Time.now.utc,
            source:                  "rspec",
            text:                    "default text",
            possibly_sensitive?:     false,
            retweet?:                true
          )
        end
        describe "#user" do
          it do
            expect(subject.user).to have_attributes(
              id: twitter_account_id,
              protected?: false
            )
          end
        end
        describe "#place" do
          it { expect(subject.place).to have_attributes(full_name: "place full name") }
        end
        describe "#retweeted_tweet" do
          it do
            expect(subject.retweeted_tweet).to have_attributes(
              text: "rt text",
              source: "rt source",
              created_at: Time.now.utc
            )
          end
          it do
            expect(subject.retweeted_tweet.user).to have_attributes(
              name: "rt name",
              screen_name: "rt_screen_name"
            )
          end
        end
        describe "#hashtags" do
          it { expect(subject.hashtags.count).to eq 2 }
          it do
            expect(subject.hashtags.first).to have_attributes(
              text: "hashtag 1", indices: [0, 10]
            )
          end
          it do
            expect(subject.hashtags.last).to have_attributes(
              text: "hashtag 2", indices: [0, 10]
            )
          end
        end
        describe "#urls" do
          it { expect(subject.urls.count).to eq 2 }
          it do
            expect(subject.urls.first).to have_attributes(
              url: "url 1", display_url: "display url 1", indices: [0, 4]
            )
          end
          it do
            expect(subject.urls.last).to have_attributes(
              url: "url 2", display_url: "display url 2", indices: [0, 4]
            )
          end
        end
        describe "#media" do
          it { expect(subject.media.count).to eq 2 }
          it do
            expect(subject.media.first).to have_attributes(
              url: "url 1", media_url: "media url 1", display_url: "display url 1", indices: [0, 4]
            )
          end
          it do
            expect(subject.media.last).to have_attributes(
              url: "url 2", media_url: "media url 2", display_url: "display url 2", indices: [0, 4]
            )
          end
        end
      end
    end

    describe "ability to overwrite attributes" do
      context "tweet.text is being overwritten" do
        let(:twitter_account_id) { 8888 }
        let(:text) { "text to overwrite with" }
        let(:attrs) { { text: text } }
        it "exactly overwrites tweet.text" do
          is_expected.to have_attributes(
            id:                      100,
            in_reply_to_tweet_id:    1,
            in_reply_to_user_id:     2,
            in_reply_to_screen_name: "in_reply_to_screen_name",
            retweet_count:           10,
            created_at:              Time.now.utc,
            source:                  "rspec",
            text:                    text,
            possibly_sensitive?:     false,
            retweet?:                true
          )
        end
      end
    end
  end

  describe "incomplete_hashtag_mock" do
    subject { incomplete_hashtag_mock }
    it do
      is_expected.to have_attributes(
        text: "", indices: [0, 7]
      )
    end
  end
  describe "incomplete_url_mock" do
    subject { incomplete_url_mock }
    it do
      is_expected.to have_attributes(
        url: "", display_url: "display url", indices: [0, 4]
      )
    end
  end
  describe "incomplete_media_mock" do
    subject { incomplete_media_mock }
    it do
      is_expected.to have_attributes(
        url: "", media_url: "media url", display_url: "display url", indices: [0, 4]
      )
    end
  end
end

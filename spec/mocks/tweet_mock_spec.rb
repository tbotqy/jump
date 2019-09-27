# frozen_string_literal: true

require "rails_helper"

describe TweetMock do
  include TweetMock

  describe "tweet_mock" do
    subject { tweet_mock(twitter_account_id: twitter_account_id, **attrs) }

    before { travel_to(Time.current) }
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
            retweet_count:           0,
            created_at:              Time.now.utc,
            source:                  "rspec",
            attrs:                   { full_text: "default text" },
            possibly_sensitive?:     false,
            retweet?:                false
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
          it { expect(subject.retweeted_tweet).to be_blank }
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
      context "tweet.attrs[:full_text] is being overwritten" do
        let(:twitter_account_id) { 8888 }
        let(:text) { "text to overwrite with" }
        let(:attrs) { { attrs: { full_text: text } } }
        it "exactly overwrites tweet.attrs[:text]" do
          is_expected.to have_attributes(
            id:                      100,
            in_reply_to_tweet_id:    1,
            in_reply_to_user_id:     2,
            in_reply_to_screen_name: "in_reply_to_screen_name",
            retweet_count:           0,
            created_at:              Time.now.utc,
            source:                  "rspec",
            attrs:                   { full_text: text },
            possibly_sensitive?:     false,
            retweet?:                false
          )
        end
      end
    end
  end

  describe "retweeting_tweet_mock" do
    describe "default state" do
      subject { retweeting_tweet_mock(twitter_account_id: twitter_account_id) }
      let(:twitter_account_id) { 8888 }
      before { travel_to(Time.current) }
      after  { travel_back }
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
            attrs:                   { full_text: "default text" },
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
              attrs:      { full_text: "rt full text" },
              source:     "rt source",
              created_at: Time.now.utc
            )
          end
          describe "#user" do
            it do
              expect(subject.retweeted_tweet.user).to have_attributes(
                name: "rt name",
                screen_name: "rt_screen_name"
              )
            end
          end

          describe "#hashtags" do
            it { expect(subject.retweeted_tweet.hashtags.count).to eq 2 }
            it do
              expect(subject.retweeted_tweet.hashtags.first).to have_attributes(
                text: "hashtag 1", indices: [0, 10]
              )
            end
            it do
              expect(subject.retweeted_tweet.hashtags.last).to have_attributes(
                text: "hashtag 2", indices: [0, 10]
              )
            end
          end
          describe "#urls" do
            it { expect(subject.retweeted_tweet.urls.count).to eq 2 }
            it do
              expect(subject.retweeted_tweet.urls.first).to have_attributes(
                url: "url 1", display_url: "display url 1", indices: [0, 4]
              )
            end
            it do
              expect(subject.retweeted_tweet.urls.last).to have_attributes(
                url: "url 2", display_url: "display url 2", indices: [0, 4]
              )
            end
          end
          describe "#media" do
            it { expect(subject.retweeted_tweet.media.count).to eq 2 }
            it do
              expect(subject.retweeted_tweet.media.first).to have_attributes(
                url: "url 1", media_url: "media url 1", display_url: "display url 1", indices: [0, 4]
              )
            end
            it do
              expect(subject.retweeted_tweet.media.last).to have_attributes(
                url: "url 2", media_url: "media url 2", display_url: "display url 2", indices: [0, 4]
              )
            end
          end
        end

        describe "#hashtags" do
          it { expect(subject.hashtags).to eq [] }
        end
        describe "#urls" do
          it { expect(subject.urls).to eq [] }
        end
        describe "#media" do
          it { expect(subject.media).to eq [] }
        end
      end
    end

    describe "ability to overwrite tweet.retweeted_tweet" do
      context "tweet.retweeted_tweet.attrs[:full_text] is being overwritten" do
        subject { retweeting_tweet_mock(twitter_account_id: twitter_account_id, retweeted_tweet: retweeted_tweet).retweeted_tweet }
        let(:twitter_account_id) { 8888 }
        let(:text) { "text to overwrite with" }

        let(:retweeted_tweet) { retweeted_tweet_mock(attrs: { full_text: text }) }

        before { travel_to(Time.current) }
        after  { travel_back }
        it "exactly overwrites tweet.attrs[:text]" do
          is_expected.to have_attributes(
            attrs:      { full_text: text },
            source:     "rt source",
            created_at: Time.now.utc,
          )
        end
      end
    end
  end

  describe "incomplete_retweeted_tweet_mock" do
    subject { incomplete_retweeted_tweet_mock }
    before { travel_to(Time.current) }
    after  { travel_back }
    it do
      is_expected.to have_attributes(
        attrs:      { full_text: "" },
        source:     "rt source",
        created_at: Time.now.utc
      )
    end
    describe "#user" do
      it do
        expect(subject.user).to have_attributes(
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

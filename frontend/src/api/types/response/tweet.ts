import { TweetUser } from "./user";

export interface UrlEntity {
  url: string;
  displayUrl: string;
  directUrl?: string;
  indices: [number, number];
}

interface TweetBase {
  tweetId: string;
  text: string;
  tweetedAt: string;
  urls: UrlEntity[];
  user: TweetUser;
}

interface NormalTweet extends TweetBase {
  isRetweet: false;
}

interface Retweet extends TweetBase {
  isRetweet: true;
  rtAvatarUrl: string;
  rtName: string;
  rtScreenName: string;
  rtText: string;
  rtCreatedAt: string;
}

export type Tweet = NormalTweet | Retweet

import { TweetUser } from "./user";

export interface UrlEntity {
  url: string;
  display_url: string;
  indices: [number, number];
}

interface TweetBase {
  tweet_id: string;
  text: string;
  tweeted_at: string;
  urls: UrlEntity[];
  user: TweetUser;
}

interface NormalTweet extends TweetBase {
  is_retweet: false;
}

interface Retweet extends TweetBase {
  is_retweet: true;
  rt_avatar_url: string;
  rt_name: string;
  rt_screen_name: string;
  rt_text: string;
  rt_created_at: string;
}

export type Tweet = NormalTweet | Retweet

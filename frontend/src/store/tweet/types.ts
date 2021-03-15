import { Tweet } from "../../api";

export interface TweetState {
  readonly tweets: Tweet[];
  readonly noTweetFound: boolean;
}

export const SET_TWEETS = "SET_TWEETS";
export const APPEND_TWEETS = "APPEND_TWEETS";

export interface SetTweetsAction {
  type: typeof SET_TWEETS;
  tweets: Tweet[];
}

interface AppendTweetsAction {
  type: typeof APPEND_TWEETS;
  tweets: Tweet[];
}

export type TweetActionTypes = SetTweetsAction | AppendTweetsAction;

import { Tweet } from "../../api";

export interface TweetState {
  readonly tweets: Tweet[];
  readonly hasMore: boolean;
  readonly noTweetFound: boolean;
}

export const SET_TWEETS = "SET_TWEETS";
export const APPEND_TWEETS = "APPEND_TWEETS";
export const SET_HAS_MORE = "SET_HAS_MORE";
export const RESET_HAS_MORE = "RESET_HAS_MORE";

export interface SetTweetsAction {
  type: typeof SET_TWEETS;
  tweets: Tweet[];
}

interface AppendTweetsAction {
  type: typeof APPEND_TWEETS;
  tweets: Tweet[];
}

interface SetHasMoreAction {
  type: typeof SET_HAS_MORE;
  flag: boolean;
}

interface ResetHasMoreAction {
  type: typeof RESET_HAS_MORE;
}

export type TweetActionTypes =
  SetTweetsAction |
  AppendTweetsAction |
  SetHasMoreAction |
  ResetHasMoreAction;

import { User } from "../user/types";

interface UrlEntity {
  url: string;
  display_url: string;
  indices: [number, number];
}

export interface Tweet {
  tweet_id: number;
  text: string;
  tweeted_at: string;
  rt_avatar_url?: string;
  rt_name?: string;
  rt_screen_name?: string;
  rt_text?: string;
  rt_created_at?: string;
  urls: UrlEntity[];
  user: User;
}

export interface TweetState {
  tweets: Tweet[];
  isFetching: boolean;
  hasMore: boolean;
  noTweetFound: boolean;
}

export const SET_TWEETS = "SET_TWEETS";
export const APPEND_TWEETS = "APPEND_TWEETS";
export const SET_IS_FETCHING = "SET_IS_FETCHING";
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

interface SetIsFetchingAction {
  type: typeof SET_IS_FETCHING;
  flag: boolean;
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
  SetIsFetchingAction |
  SetHasMoreAction |
  ResetHasMoreAction;
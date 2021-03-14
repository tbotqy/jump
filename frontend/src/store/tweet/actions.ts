import {
  TweetActionTypes,
  SET_TWEETS,
  APPEND_TWEETS,
  SET_HAS_MORE,
  RESET_HAS_MORE
} from "./types";
import { Tweet } from "../../api";

export function setTweets(tweets: Tweet[]): TweetActionTypes {
  return {
    type: SET_TWEETS,
    tweets
  };
}

export function appendTweets(tweets: Tweet[]): TweetActionTypes {
  return {
    type: APPEND_TWEETS,
    tweets
  };
}

export function setHasMore(flag: boolean): TweetActionTypes {
  return {
    type: SET_HAS_MORE,
    flag
  };
}

export function resetHasMore(): TweetActionTypes {
  return {
    type: RESET_HAS_MORE
  };
}

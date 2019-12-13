import {
  TweetActionTypes,
  SET_TWEETS,
  APPEND_TWEETS,
  SET_IS_FETCHING,
  SET_HAS_MORE,
  RESET_HAS_MORE
} from "./types";
import { Tweet } from "../../models/tweet";

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

export function setIsFetching(flag: boolean): TweetActionTypes {
  return {
    type: SET_IS_FETCHING,
    flag
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

import {
  TweetActionTypes,
  SET_TWEETS,
  APPEND_TWEETS,
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

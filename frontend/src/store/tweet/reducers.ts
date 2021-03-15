import {
  TweetState,
  TweetActionTypes,
  SET_TWEETS,
  APPEND_TWEETS,
} from "./types";

const initialState: TweetState = {
  tweets: [],
  noTweetFound: false
};

export default function tweetsReducer(
  state = initialState,
  action: TweetActionTypes
): TweetState {
  switch (action.type) {
  case SET_TWEETS:
    return {
      ...state,
      tweets: action.tweets
    };
  case APPEND_TWEETS:
    return {
      ...state,
      tweets: state.tweets.concat(action.tweets)
    };
  default:
    return state;
  }
}

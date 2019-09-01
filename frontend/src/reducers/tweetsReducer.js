const initialState = {
  tweets: [],
  isFetching: false,
  hasMore: true,
  noTweetFound: false
};

export default function tweetsReducer(state = initialState, action) {
  switch (action.type) {
  case "SET_TWEETS":
    return {
      ...state,
      tweets: action.tweets
    };
  case "APPEND_TWEETS":
    return {
      ...state,
      tweets: state.tweets.concat(action.tweets)
    };
  case "SET_IS_FETCHING":
    return {
      ...state,
      isFetching: action.flag
    };
  case "SET_HAS_MORE":
    return {
      ...state,
      hasMore: action.flag
    };
  case "RESET_HAS_MORE":
    return {
      ...state,
      hasMore: initialState.hasMore
    };
  default:
    return state;
  }
}

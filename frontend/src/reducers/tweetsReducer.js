const initialState = {
  tweets: [],
  isFetching: false,
  isFetchingMore: false
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
  case "SET_IS_FETCHING_MORE":
    return {
      ...state,
      isFetchingMore: action.flag
    };
  case "FAILED_TO_FETCH_TWEETS":
    return {
      ...state,
      isFetching: action.isFetching
    };
  default:
    return state;
  }
}

const initialState = {
  tweets: [],
  isFetching: false
};

export default function tweetsReducer(state = initialState, action) {
  switch (action.type) {
  case "SET_TWEETS":
    return {
      ...state,
      tweets: action.tweets
    };
  case "STARTED_TO_FETCH_TWEETS":
    return {
      ...state,
      isFetching: action.isFetching
    };
  case "FINISHED_TO_FETCH_TWEETS":
    return {
      ...state,
      isFetching: action.isFetching
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

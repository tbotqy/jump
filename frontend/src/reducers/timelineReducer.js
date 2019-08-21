const initialState = {
  timelineBasePath: null,
  currentPage: 1,
  noMoreTweets: false
};

export default function timelineReducer(state = initialState, action) {
  switch(action.type) {
  case "SET_TIMELINE_BASE_PATH":
    return {
      ...state,
      timelineBasePath: action.path
    };
  case "SET_CURRENT_PAGE":
    return {
      ...state,
      currentPage: action.page
    };
  case "SET_NO_MORE_TWEETS":
    return {
      ...state,
      noMoreTweets: action.flag
    };
  default:
    return state;
  }
}

export function setTweets(tweets) {
  return {
    type: "SET_TWEETS",
    tweets
  };
}

export function appendTweets(tweets) {
  return {
    type: "APPEND_TWEETS",
    tweets
  };
}

export function setIsFetching(flag) {
  return {
    type: "SET_IS_FETCHING",
    flag
  };
}

export function setHasMore(flag) {
  return {
    type: "SET_HAS_MORE",
    flag
  };
}

export function resetHasMore() {
  return {
    type: "RESET_HAS_MORE"
  };
}

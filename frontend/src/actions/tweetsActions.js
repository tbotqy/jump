import api from "../utils/api";

export function fetchPublicTweets(year, month, day, page) {
  const params = { year: year, month: month, day: day, page: page };
  return () => api.get("/statuses", params);
}

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

import api from "../utils/api";
import Cookie from "js-cookie";

export function fetchPublicTweets(year, month, day, page) {
  const params = { year, month, day, page };
  return () => api.get("/statuses", params);
}

export function fetchUserTweets(year, month, day, page) {
  const userId = Cookie.get("user_id");
  const params = { year, month, day, page };
  return () => api.get(`/users/${userId}/statuses`, params);
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

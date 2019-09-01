import api from "../utils/api";
import getUserIdFromCookie from "../utils/getUserIdFromCookie";

export function fetchPublicTweets(year, month, day, page) {
  const params = { year, month, day, page };
  return () => api.get("/statuses", params);
}

export function fetchUserTweets(year, month, day, page) {
  const userId = getUserIdFromCookie();
  const params = { year, month, day, page };
  return () => api.get(`/users/${userId}/statuses`, params);
}

export function fetchFolloweeTweets(year, month, day, page) {
  const userId = getUserIdFromCookie();
  const params = { year, month, day, page };
  return () => api.get(`/users/${userId}/followee_statuses`, params);
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

export function resetHasMore() {
  return {
    type: "RESET_HAS_MORE"
  };
}

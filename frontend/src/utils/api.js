import axios from "axios";
import getUserIdFromCookie from "./getUserIdFromCookie";

axios.defaults.withCredentials = true;
axios.defaults.headers["X-Requested-With"] = "XMLHttpRequest";

export const API_NORMAL_CODE_OK               = 200;
export const API_NORMAL_CODE_ACCEPTED         = 202;
export const API_ERROR_CODE_BAD_REQUEST       = 400;
export const API_ERROR_CODE_UNAUTHORIZED      = 401;
export const API_ERROR_CODE_NOT_FOUND         = 404;
export const API_ERROR_CODE_TOO_MANY_REQUESTS = 429;

const apiOrigin = process.env.REACT_APP_API_ORIGIN;

const api = {
  get: (path, params = {}) => {
    return axios.get(apiOrigin + path, { params });
  },
  post: (path, params = {}) => {
    return axios.post(apiOrigin + path, { params });
  },
  put: path => {
    return axios.put(apiOrigin + path);
  },
  delete: path => {
    return axios.delete(apiOrigin + path);
  }
};

export default api;

const authenticatedUserId = getUserIdFromCookie();

/*
 * User
 */

export function fetchAuthenticatedUser() {
  return api.get("/me");
}

export function fetchUserByScreenName(screenName) {
  return api.get(`/users/${screenName}`);
}

export function deleteUser() {
  return api.delete(`/users/${authenticatedUserId}`);
}

/*
 * Tweet
 */

export function fetchPublicTweets(year, month, day, page) {
  const params = { year, month, day, page };
  return api.get("/statuses", params);
}

export function fetchUserTweets(year, month, day, page = 1, userId = authenticatedUserId) {
  const params = { year, month, day, page };
  return api.get(`/users/${userId}/statuses`, params);
}

export function fetchFolloweeTweets(year, month, day, page) {
  const params = { year, month, day, page };
  return api.get(`/users/${authenticatedUserId}/followees/statuses`, params);
}

export function requestInitialTweetImport() {
  return api.post(`/users/${authenticatedUserId}/statuses`);
}

export function requestAdditionalTweetImport() {
  return api.put(`/users/${authenticatedUserId}/statuses`);
}

/*
 * SelectableDate
 */

export function fetchPublicSelectableDates() {
  return api.get("/tweeted_dates");
}

export function fetchUserSelectableDates(userId = authenticatedUserId) {
  return api.get(`/users/${userId}/tweeted_dates`);
}

export function fetchFolloweeSelectableDates() {
  return api.get(`/users/${authenticatedUserId}/followees/tweeted_dates`);
}

/*
 * Followee
 */

export function requestFolloweeImport() {
  return api.post(`/users/${authenticatedUserId}/followees`);
}

/*
 * ImportProgress
 */

export function fetchImportProgress() {
  return api.get(`/users/${authenticatedUserId}/tweet_import_progress`);
}

/*
 * stats
 */

export function fetchStats() {
  return api.get("/stats");
}

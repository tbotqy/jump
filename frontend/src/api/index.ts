import axios, { AxiosPromise } from "axios";
import getUserIdFromCookie from "../utils/getUserIdFromCookie";
import {
  User,
  Tweet,
  PaginatableDateParams,
  TweetDate,
  ImportProgress,
  Stats,
  NewArrival
} from "./types";
export * from "./types";

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
  get: (path: string, params = {}): AxiosPromise => {
    return axios.get(apiOrigin + path, { params });
  },
  post: (path: string, params = {}): AxiosPromise => {
    return axios.post(apiOrigin + path, { params });
  },
  put: (path: string): AxiosPromise => {
    return axios.put(apiOrigin + path);
  },
  delete: (path: string): AxiosPromise => {
    return axios.delete(apiOrigin + path);
  }
};

export default api;

const authenticatedUserId: number | undefined = getUserIdFromCookie();

/*
 * User
 */

export function fetchAuthenticatedUser(): AxiosPromise<User> {
  return api.get("/me");
}

export function fetchUserByScreenName(screenName: string): AxiosPromise<User> {
  return api.get(`/users/${screenName}`);
}

export function deleteUser(): AxiosPromise {
  return api.delete(`/users/${authenticatedUserId}`);
}

/*
 * Tweet
 */

export function fetchPublicTweets(params: PaginatableDateParams): AxiosPromise<Tweet[]> {
  return api.get("/statuses", params);
}

export function fetchUserTweets(params: PaginatableDateParams, userId = authenticatedUserId): AxiosPromise<Tweet[]> {
  return api.get(`/users/${userId}/statuses`, params);
}

export function fetchFolloweeTweets(params: PaginatableDateParams): AxiosPromise<Tweet[]> {
  return api.get(`/users/${authenticatedUserId}/followees/statuses`, params);
}

export function requestInitialTweetImport(): AxiosPromise {
  return api.post(`/users/${authenticatedUserId}/statuses`);
}

export function requestAdditionalTweetImport(): AxiosPromise {
  return api.put(`/users/${authenticatedUserId}/statuses`);
}

/*
 * SelectableDate TODO: rename to TweetDate
 */

export function fetchPublicSelectableDates(): AxiosPromise<TweetDate[]> {
  return api.get("/tweeted_dates");
}

export function fetchUserSelectableDates(userId = authenticatedUserId): AxiosPromise<TweetDate[]> {
  return api.get(`/users/${userId}/tweeted_dates`);
}

export function fetchFolloweeSelectableDates(): AxiosPromise<TweetDate[]> {
  return api.get(`/users/${authenticatedUserId}/followees/tweeted_dates`);
}

/*
 * Followee
 */

export function requestFolloweeImport(): AxiosPromise {
  return api.post(`/users/${authenticatedUserId}/followees`);
}

/*
 * ImportProgress
 */

export function fetchImportProgress(): AxiosPromise<ImportProgress> {
  return api.get(`/users/${authenticatedUserId}/tweet_import_progress`);
}

/*
 * stats
 */

export function fetchStats(): AxiosPromise<Stats> {
  return api.get("/stats");
}

/*
 * New arrivals
 */

export function fetchNewArrivals(): AxiosPromise<NewArrival[]> {
  return api.get("/users");
}

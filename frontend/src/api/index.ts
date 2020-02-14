import client from "./client";
import { AxiosPromise } from "axios";
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

export const API_NORMAL_CODE_OK               = 200;
export const API_NORMAL_CODE_ACCEPTED         = 202;
export const API_ERROR_CODE_UNAUTHORIZED      = 401;
export const API_ERROR_CODE_NOT_FOUND         = 404;
export const API_ERROR_CODE_TOO_MANY_REQUESTS = 429;

const apiOrigin = process.env.REACT_APP_API_ORIGIN;

const api = {
  get: (path: string, params = {}): AxiosPromise => {
    return client.get(apiOrigin + path, { params });
  },
  post: (path: string, params = {}): AxiosPromise => {
    return client.post(apiOrigin + path, { params });
  },
  put: (path: string): AxiosPromise => {
    return client.put(apiOrigin + path);
  },
  delete: (path: string): AxiosPromise => {
    return client.delete(apiOrigin + path);
  }
};

export default api;

/*
 * User
 */

export function fetchMe(): AxiosPromise<User> {
  return api.get("/me");
}

export function fetchUserByScreenName(screenName: string): AxiosPromise<User> {
  return api.get(`/users/${screenName}`);
}

export function deleteMe(): AxiosPromise {
  return api.delete("/me");
}

/*
 * Tweet
 */

export function fetchPublicTweets(params: PaginatableDateParams): AxiosPromise<Tweet[]> {
  return api.get("/statuses", params);
}

export function fetchMeTweets(params: PaginatableDateParams): AxiosPromise<Tweet[]> {
  return api.get("/me/statuses", params);
}

export function fetchUserTweets(params: PaginatableDateParams, userId: number): AxiosPromise<Tweet[]> {
  return api.get(`/users/${userId}/statuses`, params);
}

export function fetchMeFolloweeTweets(params: PaginatableDateParams): AxiosPromise<Tweet[]> {
  return api.get("/me/followees/statuses", params);
}

export function requestInitialTweetImport(): AxiosPromise {
  return api.post("/me/statuses");
}

export function requestAdditionalTweetImport(): AxiosPromise {
  return api.put("/me/statuses");
}

/*
 * SelectableDate TODO: rename to TweetDate
 */

export function fetchPublicSelectableDates(): AxiosPromise<TweetDate[]> {
  return api.get("/tweeted_dates");
}

export function fetchMeSelectableDates(): AxiosPromise<TweetDate[]> {
  return api.get("/me/tweeted_dates");
}

export function fetchUserSelectableDates(userId: number): AxiosPromise<TweetDate[]> {
  return api.get(`/users/${userId}/tweeted_dates`);
}

export function fetchMeFolloweeSelectableDates(): AxiosPromise<TweetDate[]> {
  return api.get("/me/followees/tweeted_dates");
}

/*
 * Followee
 */

export function requestFolloweeImport(): AxiosPromise {
  return api.post("/me/followees");
}

/*
 * ImportProgress
 */

export function fetchImportProgress(): AxiosPromise<ImportProgress> {
  return api.get("/me/tweet_import_progress");
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

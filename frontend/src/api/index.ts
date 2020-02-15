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

export const API_NORMAL_CODE_OK = 200;
export const API_NORMAL_CODE_ACCEPTED = 202;
export const API_ERROR_CODE_NOT_FOUND = 404;

/*
 * User
 */

export function fetchMe(): AxiosPromise<User> {
  return client.get("/me");
}

export function fetchUserByScreenName(screenName: string): AxiosPromise<User> {
  return client.get(`/users/${screenName}`);
}

export function deleteMe(): AxiosPromise {
  return client.delete("/me");
}

/*
 * Tweet
 */

export function fetchPublicTweets(params: PaginatableDateParams): AxiosPromise<Tweet[]> {
  return client.get("/statuses", { params });
}

export function fetchMeTweets(params: PaginatableDateParams): AxiosPromise<Tweet[]> {
  return client.get("/me/statuses", { params });
}

export function fetchUserTweets(params: PaginatableDateParams, userId: number): AxiosPromise<Tweet[]> {
  return client.get(`/users/${userId}/statuses`, { params });
}

export function fetchMeFolloweeTweets(params: PaginatableDateParams): AxiosPromise<Tweet[]> {
  return client.get("/me/followees/statuses", { params });
}

export function requestInitialTweetImport(): AxiosPromise {
  return client.post("/me/statuses");
}

export function requestAdditionalTweetImport(): AxiosPromise {
  return client.put("/me/statuses");
}

/*
 * SelectableDate TODO: rename to TweetDate
 */

export function fetchPublicSelectableDates(): AxiosPromise<TweetDate[]> {
  return client.get("/tweeted_dates");
}

export function fetchMeSelectableDates(): AxiosPromise<TweetDate[]> {
  return client.get("/me/tweeted_dates");
}

export function fetchUserSelectableDates(userId: number): AxiosPromise<TweetDate[]> {
  return client.get(`/users/${userId}/tweeted_dates`);
}

export function fetchMeFolloweeSelectableDates(): AxiosPromise<TweetDate[]> {
  return client.get("/me/followees/tweeted_dates");
}

/*
 * Followee
 */

export function requestFolloweeImport(): AxiosPromise {
  return client.post("/me/followees");
}

/*
 * ImportProgress
 */

export function fetchImportProgress(): AxiosPromise<ImportProgress> {
  return client.get("/me/tweet_import_progress", {
    validateStatus: status => (status >= 200 && status < 300) || status === 404
  });
}

/*
 * stats
 */

export function fetchStats(): AxiosPromise<Stats> {
  return client.get("/stats");
}

/*
 * New arrivals
 */

export function fetchNewArrivals(): AxiosPromise<NewArrival[]> {
  return client.get("/users");
}

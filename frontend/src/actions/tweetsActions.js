import api from "../utils/api";

export function fetchPublicTweets(year, month, day) {
  const params = { year: year, month: month, day: day };
  return dispatch => {
    dispatch(startedToFetchTweets());
    return api.get("/statuses", params)
      .then(response => response.data)
      .then(tweets => {
        dispatch(setTweets(tweets));
        dispatch(finishedToFetchTweets());
      });
  };
}

export function setTweets(tweets) {
  return {
    type: "SET_TWEETS",
    tweets
  };
}

export function startedToFetchTweets() {
  return {
    type: "STARTED_TO_FETCH_TWEETS",
    isFetching: true
  };
}

export function finishedToFetchTweets() {
  return {
    type: "FINISHED_TO_FETCH_TWEETS",
    isFetching: false
  };
}

export function failedToFetchTweets() {
  return {
    type: "FAILED_TO_FETCH_TWEETS",
    isFetching: false
  };
}

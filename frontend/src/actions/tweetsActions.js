import api from "../utils/api";

export function fetchPublicTweets(year, month, day) {
  const params = { year: year, month: month, day: day };
  return dispatch => {
    dispatch(startToFetchTweets());
    return api.get("/statuses", params)
      .then(response => response.data)
      .then(tweets => {
        dispatch(setTweets(tweets));
        dispatch(finishToFetchTweets());
      });
  };
}

export function setTweets(tweets) {
  return {
    type: "SET_TWEETS",
    tweets
  };
}

export function startToFetchTweets() {
  return {
    type: "START_TO_FETCH_TWEETS",
    isFetching: true
  };
}

export function finishToFetchTweets() {
  return {
    type: "FINISH_TO_FETCH_TWEETS",
    isFetching: false
  };
}

export function failedToFetchTweets() {
  return {
    type: "FAILED_TO_FETCH_TWEETS",
    isFetching: false
  };
}

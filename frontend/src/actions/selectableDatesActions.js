import api from "../utils/api";

export function fetchPublicSelectableDates() {
  return dispatch => {
    dispatch(startToFetchSelectableDates());
    api.get("/tweeted_dates")
      .then(response => response.data)
      .then(selectableDates => {
        dispatch(setSelectedYear("2019"));
        dispatch(setSelectedMonth("8"));
        dispatch(setSelectedDay("16"));
        dispatch(setSelectableDates(selectableDates));
        dispatch(finishToFetchSelectableDates());
      });
  };
}

export function setSelectableDates(selectableDates) {
  return {
    type: "SET_SELECTABLE_DATES",
    selectableDates
  };
}

export function setSelectedYear(selectedYear) {
  return {
    type: "SET_SELECTED_YEAR",
    selectedYear
  };
}

export function setSelectedMonth(selectedMonth) {
  return {
    type: "SET_SELECTED_MONTH",
    selectedMonth
  };
}

export function setSelectedDay(selectedDay) {
  return {
    type: "SET_SELECTED_DAY",
    selectedDay
  };
}

export function startToFetchSelectableDates() {
  return {
    type: "START_TO_FETCH_SELECTABLE_DATES",
    isFetching: true
  };
}

export function finishToFetchSelectableDates() {
  return {
    type: "FINISH_TO_FETCH_SELECTABLE_DATES",
    isFetching: false
  };
}

export function failedToFetchSelectableDates() {
  return {
    type: "FAILED_TO_FETCH_SELECTABLE_DATES",
    isFetching: false
  };
}

import api from "../utils/api";

export function fetchPublicSelectableDates() {
  return () => api.get("/tweeted_dates").then(response => response.data);
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

export function finishedToFetchSelectableDates() {
  return {
    type: "FINISHED_TO_FETCH_SELECTABLE_DATES",
    loaded: true
  };
}

import api from "../utils/api";
import getUserIdFromCookie from "../utils/getUserIdFromCookie";

export function fetchPublicSelectableDates() {
  return () => api.get("/tweeted_dates");
}

export function fetchUserSelectableDates() {
  const userId = getUserIdFromCookie();
  return () => api.get(`/users/${userId}/tweeted_dates`);
}

export function setSelectableDates(selectableDates) {
  return {
    type: "SET_SELECTABLE_DATES",
    selectableDates
  };
}

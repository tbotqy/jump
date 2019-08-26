import api from "../utils/api";
import Cookie from "js-cookie";

export function fetchPublicSelectableDates() {
  return () => api.get("/tweeted_dates");
}

export function fetchUserSelectableDates() {
  const userId = Cookie.get("user_id");
  return () => api.get(`/users/${userId}/tweeted_dates`);
}

export function setSelectableDates(selectableDates) {
  return {
    type: "SET_SELECTABLE_DATES",
    selectableDates
  };
}

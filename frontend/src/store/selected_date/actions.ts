import {
  SelectedDateActionTypes,
  SET_SELECTED_YEAR,
  SET_SELECTED_MONTH,
  SET_SELECTED_DAY
} from "./types";

export function setSelectedYear(year: string): SelectedDateActionTypes {
  return {
    type: SET_SELECTED_YEAR,
    year
  };
}

export function setSelectedMonth(month: string): SelectedDateActionTypes {
  return {
    type: SET_SELECTED_MONTH,
    month
  };
}

export function setSelectedDay(day: string): SelectedDateActionTypes {
  return {
    type: SET_SELECTED_DAY,
    day
  };
}

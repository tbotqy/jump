import {
  SelectedDateActionTypes,
  SET_SELECTED_YEAR,
  SET_SELECTED_MONTH,
  SET_SELECTED_DAY
} from "./types";

export function setSelectedYear(year: number): SelectedDateActionTypes {
  return {
    type: SET_SELECTED_YEAR,
    year
  };
}

export function setSelectedMonth(month: number): SelectedDateActionTypes {
  return {
    type: SET_SELECTED_MONTH,
    month
  };
}

export function setSelectedDay(day: number): SelectedDateActionTypes {
  return {
    type: SET_SELECTED_DAY,
    day
  };
}

export interface SelectedDateState {
  selectedYear?:  number;
  selectedMonth?: number;
  selectedDay?:   number;
}

export const SET_SELECTED_YEAR = "SET_SELECTED_YEAR";
export const SET_SELECTED_MONTH = "SET_SELECTED_MONTH";
export const SET_SELECTED_DAY = "SET_SELECTED_DAY";

interface SetSelectedYearAction {
  type: typeof SET_SELECTED_YEAR;
  year: number;
}

interface SetSelectedMonthAction {
  type: typeof SET_SELECTED_MONTH;
  month: number;
}

interface SetSelectedDayAction {
  type: typeof SET_SELECTED_DAY;
  day: number;
}

export type SelectedDateActionTypes =
  SetSelectedYearAction |
  SetSelectedMonthAction |
  SetSelectedDayAction

export interface SelectedDateState {
  readonly selectedYear?:  string;
  readonly selectedMonth?: string;
  readonly selectedDay?:   string;
}

export const SET_SELECTED_YEAR = "SET_SELECTED_YEAR";
export const SET_SELECTED_MONTH = "SET_SELECTED_MONTH";
export const SET_SELECTED_DAY = "SET_SELECTED_DAY";

interface SetSelectedYearAction {
  type: typeof SET_SELECTED_YEAR;
  year: string;
}

interface SetSelectedMonthAction {
  type: typeof SET_SELECTED_MONTH;
  month: string;
}

interface SetSelectedDayAction {
  type: typeof SET_SELECTED_DAY;
  day: string;
}

export type SelectedDateActionTypes =
  SetSelectedYearAction |
  SetSelectedMonthAction |
  SetSelectedDayAction

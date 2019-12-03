import {
  SelectedDateState,
  SelectedDateActionTypes,
  SET_SELECTED_YEAR,
  SET_SELECTED_MONTH,
  SET_SELECTED_DAY
} from "./types";

const initialState: SelectedDateState = {
  selectedYear:  undefined,
  selectedMonth: undefined,
  selectedDay:   undefined
};

export default function selectedDateReducer(
  state = initialState,
  action: SelectedDateActionTypes
): SelectedDateState {
  switch(action.type) {
  case SET_SELECTED_YEAR:
    return {
      ...state,
      selectedYear: action.year
    };
  case SET_SELECTED_MONTH:
    return {
      ...state,
      selectedMonth: action.month
    };
  case SET_SELECTED_DAY:
    return {
      ...state,
      selectedDay: action.day
    };
  default:
    return state;
  }
}

const initialState = {
  selectedYear:    null,
  selectedMonth:   null,
  selectedDay:     null,
  selectableDates: [],
  isFetching:      false
};

export default function selectableDatesReducer(state = initialState, action) {
  switch(action.type) {
  case "SET_SELECTABLE_DATES":
    return {
      ...state,
      selectableDates: action.selectableDates
    };
  case "SET_SELECTED_YEAR":
    return {
      ...state,
      selectedYear: action.selectedYear
    };
  case "SET_SELECTED_MONTH":
    return {
      ...state,
      selectedMonth: action.selectedMonth
    };
  case "SET_SELECTED_DAY":
    return {
      ...state,
      selectedDay: action.selectedDay
    };
  case "START_TO_FETCH_SELECTABLE_DATES":
    return {
      ...state,
      isFetching: action.isFetching
    };
  case "FINISH_TO_FETCH_SELECTABLE_DATES":
    return {
      ...state,
      isFetching: action.isFetching
    };
  case "FAILED_TO_FETCH_SELECTABLE_DATES":
    return {
      ...state,
      isFetching: action.isFetching
    };
  default:
    return state;
  }
}

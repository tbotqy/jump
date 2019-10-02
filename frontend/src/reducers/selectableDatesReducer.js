const initialState = {
  selectableDates: [],
  selectedYear:  null,
  selectedMonth: null,
  selectedDay:   null
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
      selectedYear: action.year
    };
  case "SET_SELECTED_MONTH":
    return {
      ...state,
      selectedMonth: action.month
    };
  case "SET_SELECTED_DAY":
    return {
      ...state,
      selectedDay: action.day
    };
  default:
    return state;
  }
}

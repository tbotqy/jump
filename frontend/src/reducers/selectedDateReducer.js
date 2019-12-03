const initialState = {
  selectedYear:  null,
  selectedMonth: null,
  selectedDay:   null
};

export default function selectedDateReducer(state = initialState, action) {
  switch(action.type) {
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

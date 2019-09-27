const initialState = {
  selectableDates: []
};

export default function selectableDatesReducer(state = initialState, action) {
  switch(action.type) {
  case "SET_SELECTABLE_DATES":
    return {
      ...state,
      selectableDates: action.selectableDates
    };
  default:
    return state;
  }
}

const initialState = {
  page: 1
};

export default function pageReducer(state = initialState, action) {
  switch(action.type) {
  case "RESET_PAGE":
    return {
      page: initialState.page
    };
  case "SET_PAGE":
    return {
      page: action.page
    };
  default:
    return state;
  }
}

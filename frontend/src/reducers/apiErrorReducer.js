const initialState = {
  code: null
};

export default function apiErrorReducer(state = initialState, action) {
  switch(action.type) {
  case "SET_API_ERROR_CODE":
    return {
      code: action.code
    };
  default:
    return state;
  }
}

const initialState = {
  isAuthenticated: false,
  user: null
};

export default function userReducer(state = initialState, action) {
  switch (action.type) {
  case "SET_USER":
    return {
      ...state,
      user: action.user
    };
  case "SET_IS_AUTHENTICATED":
    return {
      ...state,
      isAuthenticated: action.flag
    };
  default:
    return state;
  }
}

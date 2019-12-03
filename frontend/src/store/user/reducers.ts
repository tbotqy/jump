import {
  UserState,
  UserActionTypes,
  SET_USER,
  SET_IS_AUTHENTICATED
} from "./types";

const initialState: UserState = {
  isAuthenticated: false,
  user: undefined
};

export default function userReducer(
  state = initialState,
  action: UserActionTypes
): UserState {
  switch (action.type) {
  case SET_USER:
    return {
      ...state,
      user: action.user
    };
  case SET_IS_AUTHENTICATED:
    return {
      ...state,
      isAuthenticated: action.flag
    };
  default:
    return state;
  }
}

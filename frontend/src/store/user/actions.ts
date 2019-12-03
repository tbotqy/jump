import {
  User,
  UserActionTypes,
  SET_USER,
  SET_IS_AUTHENTICATED
} from "./types";

export function setUser(user: User): UserActionTypes {
  return {
    type: SET_USER,
    user
  };
}

export function setIsAuthenticated(flag: boolean): UserActionTypes {
  return {
    type: SET_IS_AUTHENTICATED,
    flag
  };
}

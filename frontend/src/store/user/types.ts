import { User } from "../../models/user";

export interface UserState {
  readonly isAuthenticated: boolean;
  readonly user?: User;
}

export const SET_USER = "SET_USER";
export const SET_IS_AUTHENTICATED = "SET_IS_AUTHENTICATED";

interface SetUserAction {
  type: typeof SET_USER;
  user: User;
}

interface SetIsAuthenticatedAction {
  type: typeof SET_IS_AUTHENTICATED;
  flag: boolean;
}

export type UserActionTypes = SetUserAction | SetIsAuthenticatedAction

export interface ApiErrorState {
  code?: number;
}

export const SET_API_ERROR_CODE = "SET_API_ERROR_CODE";
export const RESET_API_ERROR_CODE = "RESET_API_ERROR_CODE";

interface SetApiErrorCodeAction {
  type: typeof SET_API_ERROR_CODE;
  code: number;
}

interface ResetApiErrorCodeAction {
  type: typeof RESET_API_ERROR_CODE;
}

export type ApiErrorActionTypes = SetApiErrorCodeAction | ResetApiErrorCodeAction

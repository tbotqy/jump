import {
  ApiErrorActionTypes,
  SET_API_ERROR_CODE,
  RESET_API_ERROR_CODE
} from "./types";

export function setApiErrorCode(code: number): ApiErrorActionTypes {
  return {
    type: SET_API_ERROR_CODE,
    code
  };
}

export function resetApiErrorCode(): ApiErrorActionTypes {
  return {
    type: RESET_API_ERROR_CODE
  };
}

import {
  ApiErrorState,
  ApiErrorActionTypes,
  SET_API_ERROR_CODE,
  RESET_API_ERROR_CODE
} from "./types";

const initialState: ApiErrorState = {
  code: undefined
};

export default function apiErrorReducer(
  state = initialState,
  action: ApiErrorActionTypes
): ApiErrorState {
  switch(action.type) {
  case SET_API_ERROR_CODE:
    return {
      code: action.code
    };
  case RESET_API_ERROR_CODE:
    return {
      code: initialState.code
    };
  default:
    return state;
  }
}

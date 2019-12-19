import {
  PageState,
  PageActionTypes,
  SET_PAGE,
  RESET_PAGE
} from "./types";

const initialState: PageState = {
  page: 1
};

export default function pageReducer(
  state = initialState,
  action: PageActionTypes
): PageState {
  switch(action.type) {
  case RESET_PAGE:
    return {
      page: initialState.page
    };
  case SET_PAGE:
    return {
      page: action.page
    };
  default:
    return state;
  }
}

import {
  PageActionTypes,
  SET_PAGE,
  RESET_PAGE
} from "./types";

export function setPage(page: number): PageActionTypes {
  return {
    type: SET_PAGE,
    page
  };
}

export function resetPage(): PageActionTypes {
  return {
    type: RESET_PAGE
  };
}

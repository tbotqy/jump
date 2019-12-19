export interface PageState {
  readonly page: number;
}

export const SET_PAGE = "SET_PAGE";
export const RESET_PAGE = "RESET_PAGE";

interface SetPageAction {
  type: typeof SET_PAGE;
  page: number;
}

interface ResetPageAction {
  type: typeof RESET_PAGE;
}

export type PageActionTypes = SetPageAction | ResetPageAction

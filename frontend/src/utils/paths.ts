export const ROOT_PATH              = "/";
export const SIGN_IN_URL            = `${process.env.REACT_APP_AUTH_ORIGIN}/users/auth/twitter`;
export const SIGN_OUT_URL           = `${process.env.REACT_APP_AUTH_ORIGIN}/sign_out`;
export const IMPORT_PATH            = "/import";
export const DATA_PATH              = "/data";
export const PUBLIC_TIMELINE_PATH   = "/public_timeline";
export const USER_TIMELINE_PATH     = "/user_timeline";
export const HOME_TIMELINE_PATH     = "/home_timeline";
export const TERMS_AND_PRIVACY_PATH = "/terms_and_privacy";
export const USER_PAGE_PATH         = "/users";
export const SCREEN_NAME_PARAM      = "/:screenName";
export const TIMELINE_DATE_PARAMS   = "/:year(20\\d{2})?/:month([1-9]|1[0-2])?/:day([1-9]|1[0-9]|2[0-9]|3[0-1])?";
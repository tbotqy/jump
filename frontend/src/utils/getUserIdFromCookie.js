import Cookie from "js-cookie";

export default function getUserIdFromCookie() {
  return Cookie.get("user_id");
}

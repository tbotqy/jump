import Cookie from "js-cookie";

export default function getUserIdFromCookie(): string | undefined {
  return Cookie.get("user_id");
}

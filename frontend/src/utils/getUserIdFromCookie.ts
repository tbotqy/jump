import Cookie from "js-cookie";

export default function getUserIdFromCookie(): number | undefined {
  const userId = Cookie.get("user_id");
  if(userId) return parseInt(userId);
}

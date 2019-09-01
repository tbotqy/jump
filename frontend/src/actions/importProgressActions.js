import api from "../utils/api";
import getUserIdFromCookie from "../utils/getUserIdFromCookie.js";

export function fetchImportProgress() {
  const userId = getUserIdFromCookie();
  return () => api.get(`/users/${userId}/tweet_import_progress`);
}

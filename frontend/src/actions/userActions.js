export function setUser(user) {
  return {
    type: "SET_USER",
    user
  };
}

export function setIsAuthenticated(flag) {
  return {
    type: "SET_IS_AUTHENTICATED",
    flag
  };
}

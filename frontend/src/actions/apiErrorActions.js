export function setApiErrorCode(code) {
  return {
    type: "SET_API_ERROR_CODE",
    code
  };
}

export function resetApiErrorCode() {
  return {
    type: "RESET_API_ERROR_CODE"
  };
}

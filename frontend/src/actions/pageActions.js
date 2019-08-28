export function resetPage() {
  return {
    type: "RESET_PAGE"
  };
}

export function setPage(page) {
  return {
    type: "SET_PAGE",
    page
  };
}

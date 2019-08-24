export function setTimelineBasePath(path) {
  return {
    type: "SET_TIMELINE_BASE_PATH",
    path
  };
}

export function setCurrentPage(page) {
  return {
    type: "SET_CURRENT_PAGE",
    page
  };
}

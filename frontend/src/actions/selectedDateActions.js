export function setSelectedYear(year) {
  return {
    type: "SET_SELECTED_YEAR",
    year
  };
}

export function setSelectedMonth(month) {
  return {
    type: "SET_SELECTED_MONTH",
    month
  };
}

export function setSelectedDay(day) {
  return {
    type: "SET_SELECTED_DAY",
    day
  };
}

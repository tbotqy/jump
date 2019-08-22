const initialState = {
  timelineBasePath: null
};

export default function timelineReducer(state = initialState, action) {
  switch(action.type) {
  case "SET_TIMELINE_BASE_PATH":
    return {
      ...state,
      timelineBasePath: action.path
    };
  default:
    return state;
  }
}

import {
  createStore,
  applyMiddleware,
  combineReducers
} from "redux";
import thunk from "redux-thunk";
import createSentryMiddleware from "redux-sentry-middleware";
import selectableDates from "./reducers/selectableDatesReducer";
import tweets from "./reducers/tweetsReducer";
import user from "./reducers/userReducer";
import page from "./reducers/pageReducer";
import apiError from "./reducers/apiErrorReducer";
import Sentry from "./sentry";

const reducers = combineReducers({ user, tweets, selectableDates, page, apiError });

export default createStore(
  reducers,
  applyMiddleware(thunk, createSentryMiddleware(Sentry as any))
);

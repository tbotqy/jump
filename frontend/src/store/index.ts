import {
  createStore,
  applyMiddleware,
  combineReducers
} from "redux";
import thunk from "redux-thunk";
import createSentryMiddleware from "redux-sentry-middleware";
import selectedDate from "./selected_date/reducers";
import tweets from "./tweet/reducers";
import user from "./user/reducers";
import page from "./page/reducers";
import apiError from "./api_error/reducers";
import Sentry from "../sentry";

const reducers = combineReducers({ user, tweets, selectedDate, page, apiError });

export default createStore(
  reducers,
  applyMiddleware(thunk, createSentryMiddleware(Sentry as any))
);

export type AppState = ReturnType<typeof reducers>

import React from "react";
import ReactDOM from "react-dom";
import { createStore, applyMiddleware, combineReducers } from "redux";
import { Provider } from "react-redux";
import thunk from "redux-thunk";

import selectableDatesReducer from "./reducers/selectableDatesReducer";
import tweetsReducer from "./reducers/tweetsReducer";
import timelineReducer from "./reducers/timelineReducer";

import App from "./App";
import * as serviceWorker from "./serviceWorker";

const reducers = combineReducers({ tweets: tweetsReducer, selectableDates: selectableDatesReducer, timeline: timelineReducer });
const store    = createStore(reducers, applyMiddleware(thunk));
//store.subscribe(() => console.log(store.getState()));

ReactDOM.render(
  <Provider store={ store }>
    <App />
  </Provider>,
  document.getElementById("root")
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

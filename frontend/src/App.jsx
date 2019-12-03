import React from "react";

import { ThemeProvider } from "@material-ui/styles";
import CssBaseline from "@material-ui/core/CssBaseline";
import {
  createMuiTheme,
  responsiveFontSizes
} from "@material-ui/core/styles";

import { Provider } from "react-redux";
import {
  createStore,
  applyMiddleware,
  combineReducers
} from "redux";
import thunk from "redux-thunk";

import * as Sentry from "@sentry/browser";
import createSentryMiddleware from "redux-sentry-middleware";

import selectedDateReducer from "./reducers/selectedDateReducer";
import tweetsReducer from "./reducers/tweetsReducer";
import userReducer from "./reducers/userReducer";
import pageReducer from "./reducers/pageReducer";
import apiErrorReducer from "./reducers/apiErrorReducer";

import Routes from "./Routes";
import ErrorBoundary from "./components/ErrorBoundary";

const theme = responsiveFontSizes(createMuiTheme({
  palette:{
    background:{
      default: "white"
    }
  }
}));

const DSN = process.env.REACT_APP_SENTRY_DSN;
Sentry.init({
  dsn: DSN,
  environment: process.env.NODE_ENV
});

const reducers = combineReducers({ user: userReducer, tweets: tweetsReducer, selectedDate: selectedDateReducer, page: pageReducer, apiError: apiErrorReducer });
const store    = createStore(reducers, applyMiddleware(thunk, createSentryMiddleware(Sentry)));
//store.subscribe(() => console.log(store.getState()));

class App extends React.Component {
  render() {
    return (
      <ErrorBoundary Sentry={ Sentry }>
        <Provider store={ store }>
          <ThemeProvider theme={ theme }>
            <CssBaseline />
            <Routes />
          </ThemeProvider>
        </Provider>
      </ErrorBoundary>
    );
  }
}

export default App;

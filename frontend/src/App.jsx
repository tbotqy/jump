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

import selectableDatesReducer from "./reducers/selectableDatesReducer";
import tweetsReducer from "./reducers/tweetsReducer";
import userReducer from "./reducers/userReducer";
import pageReducer from "./reducers/pageReducer";
import apiErrorReducer from "./reducers/apiErrorReducer";

import Routes from "./Routes";

const theme = responsiveFontSizes(createMuiTheme({
  palette:{
    background:{
      default: "white"
    }
  }
}));

const reducers = combineReducers({ user: userReducer, tweets: tweetsReducer, selectableDates: selectableDatesReducer, page: pageReducer, apiError: apiErrorReducer });
const store    = createStore(reducers, applyMiddleware(thunk));
//store.subscribe(() => console.log(store.getState()));

class App extends React.Component {
  render() {
    return (
      <Provider store={ store }>
        <ThemeProvider theme={ theme }>
          <CssBaseline />
          <Routes />
        </ThemeProvider>
      </Provider>
    );
  }
}

export default App;

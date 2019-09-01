import React from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";
import CssBaseline from "@material-ui/core/CssBaseline";
import { createMuiTheme, responsiveFontSizes } from "@material-ui/core/styles";
import { ThemeProvider } from "@material-ui/styles";

import {
  PUBLIC_TIMELINE_PATH,
  USER_TIMELINE_PATH,
  HOME_TIMELINE_PATH
} from "./utils/paths";

import Auth from "./containers/AuthContainer";
import Top from "./components/Top";
import ImportContainer from "./containers/ImportContainer";
import DataManagement from "./components/DataManagement";
import TermsAndPrivacy from "./components/TermsAndPrivacy";
import PublicTimelineContainer from "./containers/PublicTimelineContainer";
import UserTimelineContainer from "./containers/UserTimelineContainer";
import HomeTimelineContainer from "./containers/HomeTimelineContainer";

const theme = responsiveFontSizes(createMuiTheme({
  palette:{
    background:{
      default: "white"
    }
  }
}));

class App extends React.Component {
  render() {
    return (
      <Router>
        <ThemeProvider theme={ theme }>
          <CssBaseline />
          <Route exact path="/" component={ Top } />
          <Route exact path={ `${PUBLIC_TIMELINE_PATH}/:year?/:month?/:day?` } component={ PublicTimelineContainer } />
          <Route exact path="/terms_and_privacy" component={ TermsAndPrivacy } />
          <Auth>
            <Route exact path="/import" component={ ImportContainer } />
            <Route exact path={ `${USER_TIMELINE_PATH}/:year?/:month?/:day?` } component={ UserTimelineContainer } />
            <Route exact path={ `${HOME_TIMELINE_PATH}/:year?/:month?/:day?` } component={ HomeTimelineContainer } />
            <Route exact path="/data" component={ DataManagement } />
          </Auth>
        </ThemeProvider>
      </Router>
    );
  }
}

export default App;

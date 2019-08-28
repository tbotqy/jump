import React from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";
import CssBaseline from "@material-ui/core/CssBaseline";
import { createMuiTheme, responsiveFontSizes } from "@material-ui/core/styles";
import { ThemeProvider } from "@material-ui/styles";

import Auth from "./containers/AuthContainer";
import Top from "./components/Top";
import Import from "./components/Import";
import DataManagement from "./components/DataManagement";
import TermsAndPrivacy from "./components/TermsAndPrivacy";
import PublicTimelineContainer from "./containers/PublicTimelineContainer";
import UserTimelineContainer from "./containers/UserTimelineContainer";

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
          <Route exact path="/public_timeline/:year?/:month?/:day?" component={ PublicTimelineContainer } />
          <Route exact path="/terms_and_privacy" component={ TermsAndPrivacy } />
          <Auth>
            <Route
              exact
              path="/statuses/import"
              render={ () => <Import screenName="screen_name" /> }
            />
            <Route exact path="/user_timeline/:year?/:month?/:day?" component={ UserTimelineContainer } />
            <Route exact path="/home_timeline" component={ PublicTimelineContainer } />
            <Route exact path="/data" component={ DataManagement } />
          </Auth>
        </ThemeProvider>
      </Router>
    );
  }
}

export default App;

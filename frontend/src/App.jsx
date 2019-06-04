import React from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";
import CssBaseline from "@material-ui/core/CssBaseline";
import { createMuiTheme, responsiveFontSizes } from "@material-ui/core/styles";
import { ThemeProvider } from "@material-ui/styles";
import Top from "./components/Top";
import Import from "./components/Import";
import Timeline from "./components/Timeline.jsx";
import DataManagement from "./components/DataManagement";
import TermsAndPrivacy from "./components/TermsAndPrivacy";

const theme = responsiveFontSizes(createMuiTheme());

class App extends React.Component {
  render() {
    return (
      <Router>
        <ThemeProvider theme={ theme }>
          <CssBaseline />
          <Route exact path="/" component={ Top } />
          <Route
            exact
            path="/statuses/import"
            render={ () => <Import screenName="screen_name" /> }
          />
          <Route exact path="/public_timeline" component={ Timeline } />
          <Route exact path="/user_timeline" component={ Timeline } />
          <Route exact path="/home_timeline" component={ Timeline } />
          <Route exact path="/data" component={ DataManagement } />
          <Route exact path="/terms_and_privacy" component={ TermsAndPrivacy } />
        </ThemeProvider>
      </Router>
    );
  }
}

export default App;

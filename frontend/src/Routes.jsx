import React from "react";
import {
  BrowserRouter as Router,
  Route,
  Switch
} from "react-router-dom";

import SessionManage from "./containers/SessionManageContainer";
import Auth from "./containers/AuthContainer";
import Top from "./components/Top";
import ImportContainer from "./containers/ImportContainer";
import DataManagement from "./components/DataManagement";
import TermsAndPrivacy from "./components/TermsAndPrivacy";
import PublicTimelineContainer from "./containers/PublicTimelineContainer";
import UserTimelineContainer from "./containers/UserTimelineContainer";
import HomeTimelineContainer from "./containers/HomeTimelineContainer";

import {
  PUBLIC_TIMELINE_PATH,
  USER_TIMELINE_PATH,
  HOME_TIMELINE_PATH
} from "./utils/paths";
import ErrorBoundary from "./components/ErrorBoundary";

const Routes = () => (
  <ErrorBoundary>
    <SessionManage>
      <Router>
        <Switch>
          <Route exact path="/" component={ Top } />
          <Route exact path="/terms_and_privacy" component={ TermsAndPrivacy } />
          <Route exact path={ `${PUBLIC_TIMELINE_PATH}/:year?/:month?/:day?` } component={ PublicTimelineContainer } />
          <Auth>
            <Route exact path="/import" component={ ImportContainer } />
            <Route exact path={ `${USER_TIMELINE_PATH}/:year?/:month?/:day?` } component={ UserTimelineContainer } />
            <Route exact path={ `${HOME_TIMELINE_PATH}/:year?/:month?/:day?` } component={ HomeTimelineContainer } />
            <Route exact path="/data" component={ DataManagement } />
          </Auth>
        </Switch>
      </Router>
    </SessionManage>
  </ErrorBoundary>
);

export default Routes;

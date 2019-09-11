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
import DataManagementContainer from "./containers/DataManagementContainer";
import TermsAndPrivacy from "./components/TermsAndPrivacy";
import PublicTimelineContainer from "./containers/PublicTimelineContainer";
import UserTimelineContainer from "./containers/UserTimelineContainer";
import HomeTimelineContainer from "./containers/HomeTimelineContainer";

import {
  ROOT_PATH,
  PUBLIC_TIMELINE_PATH,
  USER_TIMELINE_PATH,
  HOME_TIMELINE_PATH,
  TERMS_AND_PRIVACY_PATH,
  IMPORT_PATH,
  DATA_PATH,
  TIMELINE_DATE_PARAMS
} from "./utils/paths";

const Routes = () => (
  <SessionManage>
    <Router>
      <Switch>
        <Route exact path={ ROOT_PATH } component={ Top } />
        <Route exact path={ TERMS_AND_PRIVACY_PATH } component={ TermsAndPrivacy } />
        <Route exact path={ PUBLIC_TIMELINE_PATH + TIMELINE_DATE_PARAMS } component={ PublicTimelineContainer } />
        <Auth>
          <Route exact path={ IMPORT_PATH } component={ ImportContainer } />
          <Route exact path={ USER_TIMELINE_PATH + TIMELINE_DATE_PARAMS } component={ UserTimelineContainer } />
          <Route exact path={ HOME_TIMELINE_PATH + TIMELINE_DATE_PARAMS } component={ HomeTimelineContainer } />
          <Route exact path={ DATA_PATH } component={ DataManagementContainer } />
        </Auth>
      </Switch>
    </Router>
  </SessionManage>
);

export default Routes;

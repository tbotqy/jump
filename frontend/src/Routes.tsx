import React from "react";
import {
  BrowserRouter as Router,
  Route,
  Switch
} from "react-router-dom";
import Analytics from "react-router-ga";

import SessionManage from "./containers/SessionManageContainer";
import Auth from "./containers/AuthContainer";
import Top from "./pages/Top";
import ImportContainer from "./containers/ImportContainer";
import DataManagementContainer from "./containers/DataManagementContainer";
import TermsAndPrivacy from "./pages/TermsAndPrivacy";
import PublicTimeline from "./pages/PublicTimeline";
import UserTimeline from "./pages/UserTimeline";
import HomeTimeline from "./pages/HomeTimeline";
import UserPageContainer from "./containers/UserPageContainer";
import NotFound from "./pages/NotFound";

import {
  ROOT_PATH,
  PUBLIC_TIMELINE_PATH,
  USER_TIMELINE_PATH,
  HOME_TIMELINE_PATH,
  TERMS_AND_PRIVACY_PATH,
  IMPORT_PATH,
  DATA_PATH,
  USER_PAGE_PATH,
  SCREEN_NAME_PARAM,
  TIMELINE_DATE_PARAMS
} from "./utils/paths";
import ScrollToTop from "./components/ScrollToTop";

const ANALYTICS_ID: string = process.env.REACT_APP_ANALYTICS_ID || "";

const Routes = (): React.ReactElement => (
  <SessionManage>
    <Router>
      <Analytics id={ ANALYTICS_ID }>
        <ScrollToTop />
        <Switch>
          <Route exact path={ ROOT_PATH } component={ Top } />
          <Route exact path={ USER_PAGE_PATH + SCREEN_NAME_PARAM + TIMELINE_DATE_PARAMS } component={ UserPageContainer } />
          <Route exact path={ TERMS_AND_PRIVACY_PATH } component={ TermsAndPrivacy } />
          <Route exact path={ PUBLIC_TIMELINE_PATH + TIMELINE_DATE_PARAMS } component={ PublicTimeline } />
          <Route
            exact
            path={ USER_TIMELINE_PATH + TIMELINE_DATE_PARAMS }
            render={ () => <Auth><UserTimeline /></Auth> }
          />
          <Route
            exact
            path={ HOME_TIMELINE_PATH + TIMELINE_DATE_PARAMS }
            render={ () => <Auth><HomeTimeline /></Auth> }
          />
          <Route
            exact
            path={ IMPORT_PATH }
            render={ () => <Auth><ImportContainer /></Auth> }
          />
          <Route
            exact
            path={ DATA_PATH }
            render={ () => <Auth><DataManagementContainer /></Auth> }
          />
          <Route exact component={ NotFound } />
        </Switch>
      </Analytics>
    </Router>
  </SessionManage>
);

export default Routes;

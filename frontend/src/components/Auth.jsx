import React from "react";
import {
  Route,
  Redirect
} from "react-router";
import getUserIdFromCookie from "../utils/getUserIdFromCookie";

class Auth extends React.Component {
  constructor(props) {
    super(props);
    this.isAuthenticated = !!getUserIdFromCookie();
    props.setIsAuthenticated(this.isAuthenticated);
  }

  render() {
    return this.isAuthenticated ? (
      <Route>{ this.props.children }</Route>
    ) : (
      <Redirect to={ "/" } />
    );
  }
}

export default Auth;

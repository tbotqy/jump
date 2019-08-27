import React from "react";
import {
  Route,
  Redirect
} from "react-router";
import getUserIdFromCookie from "../utils/getUserIdFromCookie";

class Auth extends React.Component {
  constructor(props) {
    super(props);
    this.state = { isAuthenticated: !!getUserIdFromCookie() };
  }

  render() {
    return this.state.isAuthenticated ? (
      <Route children={this.props.children} />
    ) : (
      <Redirect to={"/"} />
    )
  }
}

export default Auth;

import React from "react";
import getUserIdFromCookie from "../utils/getUserIdFromCookie";

class SessionManage extends React.Component {
  constructor(props) {
    super(props);
    const isAuthenticated = !!getUserIdFromCookie();
    props.setIsAuthenticated(isAuthenticated);
  }

  render() {
    return this.props.children;
  }
}

export default SessionManage;

import React from "react";
import { Redirect } from "react-router";

const Auth = props => {
  if(props.isAuthenticated) {
    return props.children;
  } else {
    return <Redirect to={ "/" } />;
  }
};

export default Auth;

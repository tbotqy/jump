import React from "react";
import { Redirect } from "react-router";
import { ROOT_PATH } from "../utils/paths";

const Auth = props => {
  if(props.isAuthenticated) {
    return props.children;
  } else {
    return <Redirect to={ ROOT_PATH } />;
  }
};

export default Auth;

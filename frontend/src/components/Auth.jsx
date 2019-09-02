import React from "react";
import {
  Route,
  Redirect
} from "react-router";

const Auth = props => {
  if(props.isAuthenticated) {
    return <Route>{ props.children }</Route>;
  } else {
    return <Redirect to={ "/" } />;
  }
};

export default Auth;

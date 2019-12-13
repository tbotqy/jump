import React from "react";
import { Redirect } from "react-router";
import { ROOT_PATH } from "../utils/paths";

interface Props {
  isAuthenticated: boolean;
  children: React.ReactNode;
}

type ReturnTypes = React.ReactNode | Redirect

const Auth: ReturnTypes = ({ isAuthenticated, children }: Props) => {
  if(isAuthenticated) {
    return children;
  } else {
    return <Redirect to={ ROOT_PATH } />;
  }
};

export default Auth;

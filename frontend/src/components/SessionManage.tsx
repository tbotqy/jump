import React from "react";
import getUserIdFromCookie from "../utils/getUserIdFromCookie";

interface Props {
  setIsAuthenticated: (flag: boolean) => void;
  children: React.ReactNode;
}

class SessionManage extends React.Component<Props> {
  constructor(props: Props) {
    super(props);
    const isAuthenticated = !!getUserIdFromCookie();
    props.setIsAuthenticated(isAuthenticated);
  }

  render() {
    return this.props.children;
  }
}

export default SessionManage;

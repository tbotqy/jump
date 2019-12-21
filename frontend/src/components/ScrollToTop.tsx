import React from "react";
import {
  withRouter,
  RouteComponentProps
} from "react-router-dom";

type Props = RouteComponentProps

class ScrollToTop extends React.Component<Props> {
  componentDidUpdate(prevProps: any) {
    if (this.props.location.pathname !== prevProps.location.pathname) {
      window.scrollTo(0, 0);
    }
  }

  render() {
    return null;
  }
}

export default withRouter(ScrollToTop);

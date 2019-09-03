import React from "react";
import ErrorMessage from "./ErrorMessage";

class ApiErrorBoundary extends React.Component {
  render() {
    if( this.props.apiErrorCode ) {
      return <ErrorMessage apiErrorCode={ this.props.apiErrorCode } />;
    }
    return this.props.children;
  }

  componentWillUnmount() {
    this.props.resetApiErrorCode();
  }
}

export default ApiErrorBoundary;

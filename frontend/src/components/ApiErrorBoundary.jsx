import React from "react";
import ErrorMessage from "./ErrorMessage";

const errorMessageByApiErrorCode = apiErrorCode => {
  switch(apiErrorCode) {
  case 404:
    return "データが見つかりませんでした";
  default:
    return "サーバーエラーが発生しました。時間をおいて再度お試し願います。";
  }
};

class ApiErrorBoundary extends React.Component {
  render() {
    if( this.props.apiErrorCode ) {
      return <ErrorMessage errorMessage={ errorMessageByApiErrorCode(this.props.apiErrorCode) } />;
    }
    return this.props.children;
  }

  componentWillUnmount() {
    this.props.resetApiErrorCode();
  }
}

export default ApiErrorBoundary;

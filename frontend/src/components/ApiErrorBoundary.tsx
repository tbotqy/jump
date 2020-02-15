import React from "react";
import ErrorMessage from "./ErrorMessage";
import { API_ERROR_CODE_NOT_FOUND, API_ERROR_CODE_UNAUTHORIZED } from "../api";

const errorMessageByApiErrorCode = (apiErrorCode: number): string => {
  switch(apiErrorCode) {
  case API_ERROR_CODE_NOT_FOUND:
    return "データが見つかりませんでした";
  case API_ERROR_CODE_UNAUTHORIZED:
    return "非公開データです";
  default:
    return "サーバーエラーが発生しました。時間をおいて再度お試し願います。";
  }
};

interface Props {
  apiErrorCode?: number;
  resetApiErrorCode: () => any;
}

class ApiErrorBoundary extends React.Component<Props> {
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

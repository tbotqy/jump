import React from "react";
import * as Sentry from '@sentry/browser';
import ErrorMessage from "./ErrorMessage";

const DSN = process.env.REACT_APP_SENTRY_DSN;

Sentry.init({
  dsn: DSN,
  environment: process.env.NODE_ENV
})

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasClientError: false };
  }

  static getDerivedStateFromError() {
    return { hasClientError: true };
  }

  componentDidCatch(error, errorInfo) {
    Sentry.withScope(scope => {
        scope.setExtras(errorInfo);
        Sentry.captureException(error);
    });
  }

  render() {
    if (this.state.hasClientError) {
      return <ErrorMessage errorMessage="Sorry! Something went wrong." />;
    }
    return this.props.children;
  }
}

export default ErrorBoundary;

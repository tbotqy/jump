import React from "react";
import ErrorMessage from "./ErrorMessage";

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasClientError: false };
  }

  static getDerivedStateFromError() {
    return { hasClientError: true };
  }

  componentDidCatch(error, errorInfo) {
    const { Sentry } = this.props;
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

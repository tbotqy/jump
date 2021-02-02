import React, { ErrorInfo } from "react";
import ErrorMessage from "./ErrorMessage";
import Sentry from "../sentry";

interface Props {
  children: React.ReactNode;
}

interface State {
  hasClientError: boolean;
}

class ErrorBoundary extends React.Component<Props, State> {
  state = { hasClientError: false };

  static getDerivedStateFromError() {
    return { hasClientError: true };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    Sentry.withScope(scope => {
      scope.setExtras({'React.ErrorInfo': errorInfo});
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

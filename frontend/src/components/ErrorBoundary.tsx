import React from "react";
import ErrorMessage from "./ErrorMessage";
import Sentry from "../sentry";
import { Extras } from '@sentry/types';

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

  componentDidCatch(error: Error, errorInfo: object) {
    Sentry.withScope(scope => {
      scope.setExtras(errorInfo as Extras);
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

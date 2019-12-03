import * as Sentry from "@sentry/browser";

const DSN = process.env.REACT_APP_SENTRY_DSN;
Sentry.init({
  dsn: DSN,
  environment: process.env.NODE_ENV
});

export default Sentry;

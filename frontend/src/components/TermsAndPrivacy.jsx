import React from "react";
import HeadNav from "../containers/HeadNavContainer";
import Footer from "./Footer";
import { Container } from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import TermsOfService from "./terms_and_privacy/TermsOfService";
import PrivacyPolicy from "./terms_and_privacy/PrivacyPolicy";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";

const styles = theme => ({
  container: {
    paddingTop: theme.spacing(3),
    paddingBottom: theme.spacing(3)
  }
});

class TermsAndPrivacy extends React.Component {
  render() {
    return (
      <React.Fragment>
        <HeadNav />
        <Container className={ this.props.classes.container }>
          <ApiErrorBoundary>
            <TermsOfService />
            <PrivacyPolicy />
          </ApiErrorBoundary>
        </Container>
        <Footer />
      </React.Fragment>
    );
  }
}

export default withStyles(styles)(TermsAndPrivacy);

import React from "react";
import HeadNav from "./HeadNav";
import Footer from "./Footer";
import { Container } from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import TermsOfService from "./terms_and_privacy/TermsOfService";
import PrivacyPolicy from "./terms_and_privacy/PrivacyPolicy";

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
          <TermsOfService />
          <PrivacyPolicy />
        </Container>
        <Footer />
      </React.Fragment>
    );
  }
}

export default withStyles(styles)(TermsAndPrivacy);
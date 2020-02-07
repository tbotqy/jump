import React from "react";
import HeadNav from "../containers/HeadNavContainer";
import Footer from "../components/Footer";
import { Container, createStyles, Theme } from "@material-ui/core";
import {
  withStyles,
  WithStyles
} from "@material-ui/core/styles";
import { PAGE_TITLE_TERMS_AND_PRIVACY } from "../utils/pageHead";
import TermsOfService from "../components/terms_and_privacy/TermsOfService";
import PrivacyPolicy from "../components/terms_and_privacy/PrivacyPolicy";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";
import Head from "../components/Head";

const styles = (theme: Theme) => (
  createStyles({
    container: {
      paddingTop: theme.spacing(3),
      paddingBottom: theme.spacing(3)
    }
  })
);

type Props = WithStyles<typeof styles>

const TermsAndPrivacy: React.FC<Props> = ({ classes }) => (
  <>
    <Head title={ PAGE_TITLE_TERMS_AND_PRIVACY } />
    <HeadNav />
    <Container className={ classes.container }>
      <ApiErrorBoundary>
        <TermsOfService />
        <PrivacyPolicy />
      </ApiErrorBoundary>
    </Container>
    <Footer />
  </>
);

export default withStyles(styles)(TermsAndPrivacy);

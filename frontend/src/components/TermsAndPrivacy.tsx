import React from "react";
import HeadNav from "../containers/HeadNavContainer";
import Footer from "./Footer";
import { Container, createStyles, Theme } from "@material-ui/core";
import {
  withStyles,
  WithStyles
} from "@material-ui/core/styles";
import { PAGE_TITLE_TERMS_AND_PRIVACY } from "../utils/pageHead";
import TermsOfService from "./terms_and_privacy/TermsOfService";
import PrivacyPolicy from "./terms_and_privacy/PrivacyPolicy";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";
import Head from "./Head";

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

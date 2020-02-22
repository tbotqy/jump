import React from "react";
import HeadNav from "../containers/HeadNavContainer";
import Footer from "../components/Footer";
import { Container, createStyles, Theme, Box, Typography } from "@material-ui/core";
import {
  withStyles,
  WithStyles
} from "@material-ui/core/styles";
import { PAGE_TITLE_TERMS_AND_PRIVACY } from "../utils/pageHead";
import TermsOfServiceList from "../components/terms_and_privacy/TermsOfServiceList";
import PrivacyPolicyList from "../components/terms_and_privacy/PrivacyPolicyList";
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

const Header = ({ text }: { text: string }) => <Typography variant="h6" component="h2">{text}</Typography>;

type Props = WithStyles<typeof styles>

const TermsAndPrivacy: React.FC<Props> = ({ classes }) => (
  <ApiErrorBoundary>
    <Head title={ PAGE_TITLE_TERMS_AND_PRIVACY } />
    <HeadNav />
    <Container className={ classes.container } component="main" maxWidth="md">
      <Box mt={2} component="section">
        <Header text="利用規約" />
        <article>
          <TermsOfServiceList />
        </article>
      </Box>
      <Box mt={2} component="section">
        <Header text="プライバシーポリシー" />
        <article>
          <PrivacyPolicyList />
        </article>
      </Box>
    </Container>
    <Footer />
  </ApiErrorBoundary>
);

export default withStyles(styles)(TermsAndPrivacy);

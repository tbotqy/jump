import React from "react";
import { Link } from "react-router-dom";
import {
  Grid,
  Box,
  Typography,
  Container,
  Hidden,
  Chip,
  Theme,
  createStyles,
  withStyles,
  WithStyles
} from "@material-ui/core";
import {
  PAGE_TITLE_TOP,
  TOP_DESCRIPTION
} from "../utils/pageHead";
import { TERMS_AND_PRIVACY_PATH } from "../utils/paths";
import BrandLogo from "../components/BrandLogo";
import SignInButton from "../components/SignInButton";
import Ad from "../components/Ad";
import Footer from "../components/Footer";
import LeadText from "../components/top/LeadText";
import MockUp from "../components/top/MockUp";
import Head from "../components/Head";
import NewArrivalList from "../containers/NewArrivalListContainer";
import StatsChip from "../containers/StatsChipContainer";
import ButtonToPublicTimeline from "../components/top/ButtonToPublicTimeline";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";

const styles = (theme: Theme) => (
  createStyles({
    contentContainer: {
      minHeight: "100vh",
      backgroundColor: "#f2eee6",
      paddingTop: theme.spacing(16)
    }
  })
);

type Props = WithStyles<typeof styles>;

const Top: React.FC<Props> = ({ classes }) => {
  return (
    <ApiErrorBoundary>
      <Head title={PAGE_TITLE_TOP} description={TOP_DESCRIPTION} />
      <div className={classes.contentContainer}>
        <Container>
          <Grid container>
            <Grid item md={6} sm={12}>
              <Hidden smDown><LeadText /></Hidden>
              <Hidden mdUp>
                <LeadText align="center" />
                <Box pt={6}><MockUp /></Box>
              </Hidden>
              <Grid item lg={8}>
                <Box mt={5}>
                  <Typography variant="body1" color="textSecondary" gutterBottom>
                    <BrandLogo />
                    は、みんなやあなたの過去のツイートを、クリック一つでサクサク見られるウェブサービスです
                  </Typography>
                </Box>
              </Grid>
              <Box mt={5}>
                <Grid container justify="center" spacing={4}>
                  <Grid item lg={6} xs={12}>
                    <ButtonToPublicTimeline />
                    <Box p={2} textAlign="center">
                      <StatsChip />
                    </Box>
                  </Grid>
                  <Grid item lg={6} xs={12}>
                    <SignInButton size="large" fullWidth variant="contained" text="Twitterアカウントで利用する" />
                    <Box pt={2} textAlign="center">
                      <Chip label="利用規約はこちら" component={Link} clickable to={TERMS_AND_PRIVACY_PATH} />
                    </Box>
                  </Grid>
                </Grid>
              </Box>
            </Grid>
            <Hidden smDown>
              <Grid item md={6} sm={12} justify="center">
                <MockUp />
              </Grid>
            </Hidden>
          </Grid>
          <Box pt={6} pb={6}>
            <NewArrivalList />
          </Box>
        </Container>
        <Box pt={5} textAlign="center">
          <Ad slot={process.env.REACT_APP_AD_SLOT_TOP || ""} />
        </Box>
      </div>
      <Footer bgCaramel />
    </ApiErrorBoundary>
  );
};

export default withStyles(styles)(Top);

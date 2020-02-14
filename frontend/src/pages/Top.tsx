import React from "react";
import { Link } from "react-router-dom";
import {
  Grid,
  Box,
  Typography,
  Container,
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
import MockUp from "../components/top/MockUp";
import Head from "../components/Head";
import NewArrivalList from "../components/NewArrivalList";
import StatsChip from "../components/StatsChip";
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
          <Grid container alignItems="center" justify="center" spacing={4}>
            <Grid item md={6} xs={12} component="header">
              <Typography align="center" variant="h2" component="h1" gutterBottom>
                <BrandLogo />
              </Typography>
              <Typography align="center" variant="h4" component="h2" color="textSecondary" gutterBottom>
                過去ツイへひとっ飛び!
              </Typography>
            </Grid>

            <Grid item md={6} xs={12} component="section">
              <MockUp />
            </Grid>

            <Grid item md={12} component="section">
              <Typography variant="h6" component="h3" color="textSecondary" align="center" gutterBottom>
                <BrandLogo /> は、みんなやあなたの過去のツイートを、クリック一つでサクサク見られるウェブサービスです
              </Typography>
            </Grid>

            <Grid item xs={12} component="nav">
              <Grid container justify="space-evenly" spacing={4}>
                <Grid item md={4} xs={12}>
                  <ButtonToPublicTimeline />
                  <Box pt={2} textAlign="center">
                    <StatsChip />
                  </Box>
                </Grid>
                <Grid item md={4} xs={12}>
                  <SignInButton size="large" fullWidth variant="contained" text="Twitterアカウントで利用する" />
                  <Box pt={2} textAlign="center">
                    <Chip label="利用規約はこちら" component={Link} clickable to={TERMS_AND_PRIVACY_PATH} />
                  </Box>
                </Grid>
              </Grid>
            </Grid>

            <Grid item xs={12} component="section">
              <Box textAlign="center">
                <Ad slot={process.env.REACT_APP_AD_SLOT_TOP || ""} />
              </Box>
            </Grid>

            <Grid item xs={12} component="nav">
              <NewArrivalList />
            </Grid>
          </Grid>
        </Container>
      </div>
      <Footer bgCaramel />
    </ApiErrorBoundary>
  );
};

export default withStyles(styles)(Top);

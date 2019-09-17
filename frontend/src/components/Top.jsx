import React from "react";
import { Link } from "react-router-dom";
import { withStyles } from "@material-ui/core/styles";
import {
  Grid,
  Button,
  Box,
  Typography,
  Container,
  Hidden
} from "@material-ui/core";
import {
  PAGE_TITLE_TOP,
  TOP_DESCRIPTION
} from "../utils/pageHead";
import { PUBLIC_TIMELINE_PATH } from "../utils/paths";
import { Input as InputIcon } from "@material-ui/icons";
import BrandLogo from "./BrandLogo";
import SignInButton from "./SignInButton";
import Ad from "./Ad";
import Footer from "./Footer";
import LeadText from "./top/LeadText";
import MockUp from "./top/MockUp";
import Head from "./Head";

const styles = theme => ({
  contentContainer: {
    minHeight: "100vh",
    backgroundColor: "#f2eee6",
    paddingTop: theme.spacing(16)
  },
  buttonIcon: {
    marginLeft: theme.spacing(1)
  },
  smallBrandLogo: {
    marginRight: theme.spacing(1)
  },
  adWrapper: {
    paddingTop: theme.spacing(3),
    paddingBottom: theme.spacing(3),
    textAlign: "center"
  }
});

const Top = props => (
  <React.Fragment>
    <Head title={ PAGE_TITLE_TOP } description={ TOP_DESCRIPTION } type="website" />
    <div className={ props.classes.contentContainer }>
      <Container>
        <Grid container>
          <Grid item md={ 6 } sm={ 12 }>
            <Hidden smDown>
              <LeadText />
            </Hidden>
            <Hidden mdUp>
              <LeadText align="center" />
              <Box pt={ 6 }>
                <MockUp />
              </Box>
            </Hidden>
            <Box mt={ 5 }>
              <Grid item lg={ 8 }>
                <Typography
                  variant="body1"
                  color="textSecondary"
                  gutterBottom
                >
                  <BrandLogo className={ props.classes.smallBrandLogo } />
                  は、みんなやあなたの過去のツイートを、クリック一つでサクサク見られるウェブサービスです
                </Typography>
              </Grid>
            </Box>
            <Box mt={ 5 }>
              <Grid container justify="center" spacing={ 3 }>
                <Grid item lg={ 6 } xs={ 12 }>
                  <Button
                    size="large"
                    fullWidth
                    variant="contained"
                    color="primary"
                    component={ Link }
                    to={ PUBLIC_TIMELINE_PATH }
                  >
                    公開タイムラインを見てみる
                    <InputIcon
                      fontSize="small"
                      className={ props.classes.buttonIcon }
                    />
                  </Button>
                </Grid>
                <Grid item lg={ 6 } xs={ 12 }>
                  <SignInButton
                    size="large"
                    fullWidth
                    variant="contained"
                    text="Twitterアカウントで利用する"
                  />
                </Grid>
              </Grid>
            </Box>
          </Grid>
          <Hidden smDown>
            <Grid item md={ 6 } sm={ 12 } align="center">
              <MockUp />
            </Grid>
          </Hidden>
        </Grid>
      </Container>
      <Box className={ props.classes.adWrapper }>
        <Ad slot={ process.env.REACT_APP_AD_SLOT_TOP } />
      </Box>
    </div>
    <Footer bgCaramel />
  </React.Fragment>
);

export default withStyles(styles)(Top);

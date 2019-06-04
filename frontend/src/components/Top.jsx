import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  Grid,
  Button,
  Box,
  Typography,
  Container,
  Hidden
} from "@material-ui/core";
import { Input as InputIcon } from "@material-ui/icons";
import BrandLogo from "./BrandLogo";
import SignInButton from "./SignInButton";
import Footer from "./Footer";
import LeadText from "./top/LeadText";
import MockUp from "./top/MockUp";

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
  }
});

class Top extends React.Component {
  render() {
    return (
      <React.Fragment>
        <div className={ this.props.classes.contentContainer }>
          <Container>
            <Grid container alignItems="center">
              <Grid item sm={ 6 } xs={ 12 }>
                <Hidden only="xs">
                  <LeadText />
                </Hidden>
                <Hidden smUp>
                  <LeadText align="center" />
                  <MockUp />
                </Hidden>
                <Grid item lg={ 8 }>
                  <Typography
                    variant="body1"
                    color="textSecondary"
                    gutterBottom
                  >
                    <BrandLogo className={ this.props.classes.smallBrandLogo } />
                    は、みんなやあなたの過去のツイートを、クリック一つでサクサク見られるウェブサービスです
                  </Typography>
                </Grid>
                <Box mt={ 5 }>
                  <Grid container justify="center" spacing={ 3 }>
                    <Grid item lg={ 6 } xs={ 12 }>
                      <Button
                        size="large"
                        fullWidth
                        variant="contained"
                        color="primary"
                        href="/public_timeline"
                      >
                        公開タイムラインを見てみる
                        <InputIcon
                          fontSize="small"
                          className={ this.props.classes.buttonIcon }
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
              <Hidden only="xs">
                <Grid item sm={ 6 } xs={ 12 } align="center">
                  <MockUp />
                </Grid>
              </Hidden>
            </Grid>
          </Container>
        </div>
        <Footer bgCaramel />
      </React.Fragment>
    );
  }
}

export default withStyles(styles)(Top);

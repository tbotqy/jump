import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { withStyles } from "@material-ui/core/styles";
import {
  Grid,
  Button,
  Box,
  Typography,
  Container,
  Hidden,
  Chip,
  CircularProgress,
  Avatar,
  IconButton
} from "@material-ui/core";
import shortid from "shortid";
import {
  PAGE_TITLE_TOP,
  TOP_DESCRIPTION
} from "../utils/pageHead";
import {
  PUBLIC_TIMELINE_PATH,
  TERMS_AND_PRIVACY_PATH,
  USER_PAGE_PATH
} from "../utils/paths";
import { Input as InputIcon } from "@material-ui/icons";
import BrandLogo from "./BrandLogo";
import SignInButton from "./SignInButton";
import Ad from "./Ad";
import Footer from "./Footer";
import LeadText from "./top/LeadText";
import MockUp from "./top/MockUp";
import Head from "./Head";
import {
  fetchStats,
  fetchNewArrivals,
} from "../utils/api";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";

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
  avatar: {
    width:  50,
    height: 50
  }
});

const Top = props => {
  const [ stats, setStats ] = useState(null);
  const [ newArrivals, setNewArrivals ] = useState([]);
  const { setApiErrorCode } = props;

  useEffect(() => {
    (async() => {
      try {
        const response = await fetchStats();
        setStats(response.data);
      } catch(error) {
        setApiErrorCode(error.response.status);
      }
    })();
    (async() => {
      try {
        const response = await fetchNewArrivals();
        setNewArrivals(response.data);
      } catch(error) {
        setApiErrorCode(error.response.status);
      }
    })();
  }, [ setApiErrorCode ]);

  return(
    <ApiErrorBoundary>
      <Head title={ PAGE_TITLE_TOP } description={ TOP_DESCRIPTION } />
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
                <Grid container justify="center" spacing={ 4 }>
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
                    <Box p={ 2 } textAlign="center">
                      { stats ? <Chip label={ `${stats.status_count} ツイート / ${stats.user_count} ユーザー` } /> : <CircularProgress size={ 24 } /> }
                    </Box>
                  </Grid>
                  <Grid item lg={ 6 } xs={ 12 }>
                    <SignInButton
                      size="large"
                      fullWidth
                      variant="contained"
                      text="Twitterアカウントで利用する"
                    />
                    <Box pt={ 2 } textAlign="center">
                      <Chip label="利用規約はこちら" component={ Link } clickable to={ TERMS_AND_PRIVACY_PATH } />
                    </Box>
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
          <Box pt={ 6 } pb={ 6 }>
            <Typography gutterBottom variant="h5" component="h3" color="textSecondary">新着ユーザー</Typography>
            <Box pt={ 2 }>
              {
                newArrivals.length === 0 ?
                  <Grid container alignItems="center" justify="center">
                    <Grid item>
                      <CircularProgress />
                    </Grid>
                  </Grid> :
                  <Grid container direction="row" alignItems="center" justify="space-between">
                    { newArrivals.map( user => (
                      <Grid item key={ shortid.generate() }>
                        <IconButton component={ Link } to={ `${USER_PAGE_PATH}/${user.screen_name}` }>
                          <Avatar className={ props.classes.avatar } src={ user.avatar_url.replace("_normal", "_bigger") } />
                        </IconButton>
                      </Grid>
                    ))
                    }
                  </Grid>
              }
            </Box>
          </Box>
        </Container>
        <Box pt={ 5 } textAlign="center">
          <Ad slot={ process.env.REACT_APP_AD_SLOT_TOP } />
        </Box>
      </div>
      <Footer bgCaramel />
    </ApiErrorBoundary>
  );
};

export default withStyles(styles)(Top);

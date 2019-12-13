import React from "react";
import { Link as RouterLink } from "react-router-dom";
import {
  Container,
  Grid,
  Link,
  Typography,
  IconButton,
  Theme,
  createStyles,
  WithStyles
} from "@material-ui/core";
import TwitterIcon from "@material-ui/icons/Twitter";
import { withStyles } from "@material-ui/core/styles";
import {
  ROOT_PATH,
  TERMS_AND_PRIVACY_PATH
} from "../utils/paths";
import { CARAMEL_COLOR } from "../utils/colors";
import TweetButton from "./TweetButton";

const styles = (theme: Theme) => (
  createStyles({
    container: {
      paddingTop: theme.spacing(5),
      paddingBottom: theme.spacing(5),
    },
    link: {
      paddingLeft: theme.spacing(2)
    }
  })
);

const adminTwitterScreenName = process.env.REACT_APP_ADMIN_TWITTER_SCREEN_NAME;
const serviceDomain = process.env.REACT_APP_SERVICE_DOMAIN;

interface Props extends WithStyles<typeof styles> {
  bgCaramel?: boolean;
}

const Footer: React.FC<Props> = ({ bgCaramel, classes }) => {
  const backgroundColor = bgCaramel ? CARAMEL_COLOR : "white";

  return (
    <Container
      component="footer"
      maxWidth="xl"
      className={ classes.container }
      style={ { backgroundColor } }
    >
      <Grid container direction="column" alignItems="center" justify="center" spacing={ 2 }>
        <Grid item>
          <TweetButton />
        </Grid>
        <Grid item>
          <Typography variant="subtitle1" color="textSecondary">
            <Link
              color="inherit"
              component={ RouterLink }
              to={ TERMS_AND_PRIVACY_PATH }
            >
              利用規約・プライバシーポリシー
            </Link>
          </Typography>
        </Grid>
        <Grid item>
          <Grid container direction="row" justify="center" alignItems="center" spacing={ 2 }>
            <Grid item>
              <IconButton href={ `//twitter.com/${adminTwitterScreenName}` } target="_blank">
                <TwitterIcon />
              </IconButton>
            </Grid>
            <Grid item>
              <Typography color="textSecondary">
                © 2012-{ new Date().getFullYear() }
              </Typography>
            </Grid>
            <Grid item>
              <Typography color="textSecondary">
                <Link
                  color="inherit"
                  component={ RouterLink }
                  to={ ROOT_PATH }
                >
                  { serviceDomain }
                </Link>
              </Typography>
            </Grid>
          </Grid>
        </Grid>
      </Grid>
    </Container>
  );
};

export default withStyles(styles)(Footer);

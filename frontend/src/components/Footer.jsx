import React from "react";
import { Link as RouterLink } from "react-router-dom";
import {
  Container,
  Grid,
  Link,
  Typography,
  IconButton
} from "@material-ui/core";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTwitter } from "@fortawesome/free-brands-svg-icons";
import { withStyles } from "@material-ui/core/styles";
import {
  ROOT_PATH,
  TERMS_AND_PRIVACY_PATH
} from "../utils/paths";

const styles = theme => ({
  container: {
    paddingTop: theme.spacing(5),
    paddingBottom: theme.spacing(5),
  },
  link: {
    paddingLeft: theme.spacing(2)
  }
});

const adminTwitterScreenName = process.env.REACT_APP_ADMIN_TWITTER_SCREEN_NAME;

const Footer = props => {
  const backgroundColor = props.bgCaramel ? "#f2eee6" : "white";

  return (
    <Container
      align="center"
      component="footer"
      maxWidth="xl"
      className={ props.classes.container }
      style={ { backgroundColor } }
    >
      <Grid container direction="column" alignItems="center" justify="center" spacing={ 2 }>
        <Grid item>
          <IconButton href={ `//twitter.com/${adminTwitterScreenName}` } target="_blank">
            <FontAwesomeIcon icon={ faTwitter }/>
          </IconButton>
        </Grid>
        <Grid item>
          <Typography color="textSecondary">
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
          <Typography color="textSecondary">
            © 2012-{ new Date().getFullYear() }
            <Link
              color="inherit"
              component={ RouterLink }
              to={ ROOT_PATH }
              className={ props.classes.link }
            >
              twitjump.me
            </Link>
          </Typography>
        </Grid>
      </Grid>
    </Container>
  );
};

export default withStyles(styles)(Footer);

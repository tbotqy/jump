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

class Footer extends React.Component {
  render() {
    return (
      <Container
        align="center"
        component="footer"
        maxWidth="xl"
        className={ this.props.classes.container }
        style={ { backgroundColor: this.backgroundColor() } }
      >
        <Grid container direction="column" alignItems="center" justify="center" spacing={ 2 }>
          <Grid item>
            <IconButton href={ `//twitter.com/${process.env.REACT_APP_ADMIN_TWITTER_SCREEN_NAME}` } target="_blank">
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
                className={ this.props.classes.link }
              >
                twitjump.me
              </Link>
            </Typography>
          </Grid>
        </Grid>
      </Container>
    );
  }

  backgroundColor() {
    return this.props.bgCaramel ? "#f2eee6" : "white";
  }
}

export default withStyles(styles)(Footer);

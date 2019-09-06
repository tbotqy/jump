import React from "react";
import { Link as RouterLink } from "react-router-dom";
import {
  Container,
  Grid,
  Link,
  Typography
} from "@material-ui/core";
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
        <Grid container justify="center" spacing={ 1 }>
          <Grid item xs={ 12 }>
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
          <Grid item xs={ 12 }>
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
        </Grid>
      </Container>
    );
  }

  backgroundColor() {
    return this.props.bgCaramel ? "#f2eee6" : "white";
  }
}

export default withStyles(styles)(Footer);

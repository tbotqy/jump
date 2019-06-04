import React from "react";
import {
  AppBar,
  Toolbar,
  Typography
} from "@material-ui/core/";
import { withStyles } from "@material-ui/core/styles";
import BrandLogo from "./BrandLogo";
import TimelineSwitch from "./head_nav/TimelineSwitch";
import UserMenu from "./head_nav/UserMenu";
import SignInButton from "./SignInButton";

const styles = (theme) => ({
  appBar: {
    backgroundColor: "#f2eee6",
    padding: theme.spacing(1)
  },
  typography: {
    flexGrow: 1
  }
});

class HeadNav extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      auth: true
    };
  }

  render() {
    return (
      <AppBar position="static" className={ this.props.classes.appBar }>
        <Toolbar>
          <Typography variant="h6" className={ this.props.classes.typography }>
            <BrandLogo />
          </Typography>
          { this.state.auth && <TimelineSwitch /> }
          { this.state.auth && <UserMenu /> }
          { !this.state.auth && <SignInButton variant="contained" text="登録" /> }
        </Toolbar>
      </AppBar>
    );
  }
}

export default withStyles(styles)(HeadNav);

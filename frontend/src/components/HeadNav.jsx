import React from "react";
import {
  AppBar,
  Toolbar,
  Typography
} from "@material-ui/core/";
import { withStyles } from "@material-ui/core/styles";
import BrandLogo from "./BrandLogo";
import TimelineSwitch from "./head_nav/TimelineSwitch";
import UserMenu from "../containers/userMenuContainer";
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
  render() {
    return (
      <AppBar position="static" className={ this.props.classes.appBar }>
        <Toolbar>
          <Typography variant="h6" className={ this.props.classes.typography }>
            <BrandLogo />
          </Typography>
          {
            this.props.isAuthenticated ? (
              <>
                <TimelineSwitch />
                <UserMenu />
              </>
            ) : ( <SignInButton variant="contained" text="利用する" /> )
          }
        </Toolbar>
      </AppBar>
    );
  }
}

export default withStyles(styles)(HeadNav);

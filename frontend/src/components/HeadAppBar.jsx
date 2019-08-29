import React from "react";
import {
  AppBar,
  Toolbar,
  Typography
} from "@material-ui/core/";
import { withStyles } from "@material-ui/core/styles";
import BrandLogo from "./BrandLogo";

const styles = theme => ({
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
          { this.props.children }
        </Toolbar>
      </AppBar>
    );
  }
}

export default withStyles(styles)(HeadNav);

import React from "react";
import {
  AppBar,
  Toolbar,
  Typography,
  createStyles,
  Theme,
  WithStyles
} from "@material-ui/core/";
import { withStyles } from "@material-ui/core/styles";
import BrandLogo from "./BrandLogo";

const styles = (theme: Theme) => createStyles({
  appBar: {
    backgroundColor: "#f2eee6",
    padding: theme.spacing(1)
  },
  typography: {
    flexGrow: 1
  }
});

type Props = WithStyles<typeof styles>

const HeadAppBar: React.FC<Props> = ({ classes, children }) => (
  <AppBar position="static" className={ classes.appBar }>
    <Toolbar>
      <Typography variant="h6" className={ classes.typography }>
        <BrandLogo />
      </Typography>
      { children }
    </Toolbar>
  </AppBar>
);

export default withStyles(styles)(HeadAppBar);

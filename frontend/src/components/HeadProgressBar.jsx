import React from "react";
import { LinearProgress } from "@material-ui/core";
import { withStyles } from "@material-ui/styles";

const styles = theme => ({
  wrapper: {
    position: "absolute",
    top: theme.spacing(10),
    width: "100%"
  }
});

const HeadProgressBar = ({ isFetching, classes }) => (
  <div className={ classes.wrapper }>
    { isFetching && <LinearProgress /> }
  </div>
);

export default withStyles(styles)(HeadProgressBar);

import React from "react";
import { LinearProgress, Theme, WithStyles } from "@material-ui/core";
import { withStyles, createStyles } from "@material-ui/styles";

const styles = (theme: Theme) => (
  createStyles({
    wrapper: {
      position: "absolute",
      top: theme.spacing(10),
      width: "100%"
    }
  })
);

interface Props extends WithStyles<typeof styles> {
  isFetching?: boolean;
}

const HeadProgressBar: React.FC<Props> = ({ isFetching, classes }) => (
  <div className={ classes.wrapper }>
    { isFetching && <LinearProgress /> }
  </div>
);

export default withStyles(styles)(HeadProgressBar);

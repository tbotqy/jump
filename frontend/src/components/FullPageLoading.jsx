import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  Grid,
  CircularProgress
} from "@material-ui/core";

const styles = () => ({
  container: {
    minHeight: "80vh"
  }
});

const FullPageLoading = ({ classes }) => (
  <Grid container direction="column" justify="center" alignItems="center" spacing={ 1 } className={ classes.container }>
    <Grid item>
      <CircularProgress />
    </Grid>
  </Grid>
);

export default withStyles(styles)(FullPageLoading);

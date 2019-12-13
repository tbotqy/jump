import React from "react";
import {
  withStyles,
  WithStyles
} from "@material-ui/core/styles";
import {
  Grid,
  CircularProgress,
  createStyles
} from "@material-ui/core";

const styles = createStyles({
  container: {
    minHeight: "80vh"
  }
});

type Props = WithStyles<typeof styles>

const FullPageLoading: React.FC<Props> = ({ classes }) => (
  <Grid container direction="column" justify="center" alignItems="center" spacing={ 1 } className={ classes.container }>
    <Grid item>
      <CircularProgress />
    </Grid>
  </Grid>
);

export default withStyles(styles)(FullPageLoading);

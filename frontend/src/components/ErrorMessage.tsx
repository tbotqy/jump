import React from "react";
import {
  withStyles,
  WithStyles,
  createStyles
} from "@material-ui/core/styles";
import {
  Typography,
  Grid,
  Button,
  Divider
} from "@material-ui/core";
import { ROOT_PATH } from "../utils/paths";

const styles = createStyles({
  container: {
    minHeight: "80vh"
  },
  item: {
    textAlign: "center"
  }
});

interface Props extends WithStyles<typeof styles> {
  errorMessage: string;
}

const ErrorMessage: React.FC<Props> = ({ errorMessage, classes }) => (
  <Grid container direction="column" justify="center" alignItems="center" spacing={ 1 } className={ classes.container }>
    <Grid item>
      <Typography variant="h4" component="h1" color="textSecondary" gutterBottom>{ errorMessage }</Typography>
      <Divider variant="fullWidth" />
    </Grid>
    <Grid item>
      <Button href={ ROOT_PATH }>トップへ</Button>
    </Grid>
  </Grid>
);

export default withStyles(styles)(ErrorMessage);

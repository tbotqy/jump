import React from "react";
import { withStyles } from "@material-ui/core/styles";
import { Link } from "react-router-dom";
import {
  Grid,
  Typography,
  Button,
  Divider
} from "@material-ui/core";
import {
  PAGE_TITLE_NOT_FOUND,
  TOP_DESCRIPTION
} from "../utils/pageHead";
import Head from "./Head";

const styles = () => ({
  container: {
    minHeight: "100vh"
  }
});

const NotFound = ({ classes }) => (
  <>
    <Head title={ PAGE_TITLE_NOT_FOUND } description={ TOP_DESCRIPTION } />
    <Grid container direction="column" justify="center" alignItems="center" spacing={ 1 } className={ classes.container }>
      <Grid item>
        <Typography variant="h3" component="h1" color="textSecondary" gutterBottom>404: Page not found</Typography>
        <Divider variant="fullWidth" />
      </Grid>
      <Grid item>
        <Button component={ Link } to="/">トップへ</Button>
      </Grid>
    </Grid>
  </>
);

export default withStyles(styles)(NotFound);

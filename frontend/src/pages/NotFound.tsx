import React from "react";
import {
  withStyles,
  WithStyles
} from "@material-ui/core/styles";
import { Link } from "react-router-dom";
import {
  Grid,
  Typography,
  Button,
  Divider,
  createStyles
} from "@material-ui/core";
import {
  PAGE_TITLE_NOT_FOUND,
  TOP_DESCRIPTION
} from "../utils/pageHead";
import Head from "../components/Head";

const styles = createStyles({
  container: {
    minHeight: "100vh"
  }
});

type Props = WithStyles<typeof styles>

const NotFound: React.FC<Props> = ({ classes }) => (
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

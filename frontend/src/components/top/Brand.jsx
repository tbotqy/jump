import React from "react";
import Grid from "@material-ui/core/Grid";
import Typography from "@material-ui/core/Typography";
import BrandLogo from "../BrandLogo";

class Brand extends React.Component {
  render() {
    return (
      <Grid container justify="center" direction="column">
        <Grid item>
          <Typography variant="h2" align="center">
            <BrandLogo />
          </Typography>
        </Grid>

        <Grid item style={ { paddingTop: "20px" } }>
          <Typography variant="h5" align="center" style={ { color: "gray" } }>過去ツイへひとっ飛び</Typography>
        </Grid>
      </Grid>
    );
  }
}

export default Brand;

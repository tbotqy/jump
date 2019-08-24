import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  withRouter,
  Link
} from "react-router-dom";
import {
  Typography,
  Grid,
  Button
} from "@material-ui/core";

const styles = () => ({
  container: {
    paddingTop: "100px"
  },
  item: {
    textAlign: "center"
  }
})

const errorMessage = apiErrorCode => {
  switch(apiErrorCode){
  case 404:
    return "ツイートが見つかりませんでした :-(";
  default:
    return "サーバーエラーが発生しました";
  }
}

const Error = props => {
  return(
    <Grid container direction="row" spacing={5} className={ props.classes.container } >
      <Grid item xs={12} className={ props.classes.item } >
        <Typography variant="h4" color="textSecondary">{ errorMessage(props.apiErrorCode) }</Typography>
      </Grid>
      <Grid item xs={12} className={ props.classes.item } >
        <Button component={Link} to="/">トップへ</Button>
      </Grid>
    </Grid>
  );
}

export default withRouter(withStyles(styles)(Error));

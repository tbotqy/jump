import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  Typography,
  Grid,
  Button
} from "@material-ui/core";

const styles = theme => ({
  container: {
    paddingTop: theme.spacing(5)
  },
  item: {
    textAlign: "center"
  }
});

const errorMessageByApiErrorCode = apiErrorCode => {
  switch(apiErrorCode) {
  case 404:
    return "データが見つかりませんでした";
  default:
    return "サーバーエラーが発生しました。時間をおいて再度お試し願います。";
  }
};

const ErrorMessage = props => (
  <Grid container direction="row" spacing={ 5 } className={ props.classes.container }>
    <Grid item xs={ 12 } className={ props.classes.item } >
      <Typography variant="h4" color="textSecondary">{ props.errorMessage || errorMessageByApiErrorCode(props.apiErrorCode) }</Typography>
    </Grid>
    <Grid item xs={ 12 } className={ props.classes.item } >
      <Button href="/">トップへ</Button>
    </Grid>
  </Grid>
);

export default withStyles(styles)(ErrorMessage);

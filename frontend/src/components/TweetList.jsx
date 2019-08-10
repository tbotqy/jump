import React from "react";
import {
  Grid,
  List,
  ListItem,
  LinearProgress
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import TweetCard from "./TweetCard";

const styles = () => ({
  container: {
    minHeight: "100vh"
  }
});

const loader = () => (
  <LinearProgress />
);

const list = tweets => (
  <List>
    { tweets.map((tweet, index) => (
      <ListItem divider disableGutters key={ index }>
        <TweetCard key={ index } tweet={ tweet } />
      </ListItem>
    )) }
  </List>
);

const TweetList = props => (
  <Grid container justify="center" className={ props.classes.container }>
    <Grid item lg={ 8 }>
      { props.tweets.length <= 0 ? loader() : list(props.tweets) }
    </Grid>
  </Grid>
);

export default withStyles(styles)(TweetList);

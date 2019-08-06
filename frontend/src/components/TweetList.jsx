import React from "react";
import {
  Grid,
  List,
  ListItem
} from "@material-ui/core";
import TweetCard from "./TweetCard";

function TweetList(props) {
  return (
    <Grid container justify="center">
      <Grid item lg={ 8 }>
        <List>
          { props.tweets.map((tweet, index) => (
            <ListItem divider disableGutters key={ index }>
              <TweetCard key={ index } tweet={ tweet } />
            </ListItem>
          )) }
        </List>
      </Grid>
    </Grid>
  );
}

export default TweetList;

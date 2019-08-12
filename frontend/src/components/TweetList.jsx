import React from "react";
import {
  Grid,
  List,
  ListItem
} from "@material-ui/core";
import TweetCard from "./TweetCard";

const tweetCardPropsByTweet = tweet => {
  const ret = {
    tweetId:   tweet.tweet_id,
    isRetweet: tweet.is_retweet,
    tweetedAt: tweet.tweeted_at,
    user:      tweet.user
  };

  if(tweet.is_retweet) {
    return ({
      ...ret,
      name:       tweet.rt_name,
      screenName: tweet.rt_screen_name,
      avatarUrl:  tweet.rt_avatar_url,
      text:       tweet.rt_text
    });
  }else{
    return ({
      ...ret,
      name:       tweet.user.name,
      screenName: tweet.user.screen_name,
      avatarUrl:  tweet.user.avatar_url,
      text:       tweet.text
    });
  }
};

const TweetList = props => (
  <Grid container justify="center">
    <Grid item lg={ 8 }>
      <List>
        { props.tweets.map((tweet, index) => (
          <ListItem divider disableGutters key={ index }>
            <TweetCard key={ index } { ...tweetCardPropsByTweet(tweet) } />
          </ListItem>
        )) }
      </List>
    </Grid>
  </Grid>
);

export default TweetList;

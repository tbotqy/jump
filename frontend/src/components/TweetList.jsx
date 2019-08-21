import React from "react";
import {
  Grid,
  List,
  ListItem
} from "@material-ui/core";
import TweetCard from "./TweetCard";

const tweetCardPropsByTweet = tweet => {
  const ret = {
    tweetId:     tweet.tweet_id,
    isRetweet:   tweet.is_retweet,
    tweetedAt:   tweet.tweeted_at,
    user:        tweet.user,
    urlEntities: tweet.urls
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

const TweetList = props => {
  if(props.tweets.length > 0) {
    return(
      <Grid container justify="center">
        <Grid item lg={ 8 }>
          <List>
            { props.tweets.map((tweet) => (
              <ListItem divider disableGutters key={ tweet.tweet_id }>
                <TweetCard key={ tweet.tweet_id } { ...tweetCardPropsByTweet(tweet) } />
              </ListItem>
            )) }
          </List>
        </Grid>
      </Grid>
    );
  }else{
    return <p>ツイートが存在しません</p>;
  }
};

export default TweetList;

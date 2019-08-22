import React from "react";
import shortid from "shortid";
import InfiniteScroll from "react-infinite-scroller";
import {
  Grid,
  List,
  ListItem,
  Box,
  CircularProgress
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

const loader = (
  <Box key={ shortid.generate() } display="flex" justifyContent="center" p={ 3 }>
    <CircularProgress />
  </Box>
);

class TweetList extends React.Component {
  loadMore(nextPage) {
    const { selectedYear, selectedMonth, selectedDay } = this.props;
    this.props.tweetsFetcher(selectedYear, selectedMonth, selectedDay, nextPage)
      .then( response => {
        this.props.appendTweets(response.data);
      }).catch( error => {
        switch(error.response.status) {
        case 404:
          this.props.setHasMore(false);
          break;
        default:
          alert("error!"); // TODO: implement
        }
      });
  }

  render() {
    if(this.props.tweets.length > 0) {
      return(
        <Grid container justify="center">
          <Grid item lg={ 8 }>
            <List>
              <InfiniteScroll
                hasMore={ this.props.hasMore }
                loadMore={ this.loadMore.bind(this) }
                loader={ loader }
                pageStart={ 1 }
              >
                { this.props.tweets.map( tweet => (
                  <ListItem divider disableGutters key={ tweet.tweet_id }>
                    <TweetCard { ...tweetCardPropsByTweet(tweet) } />
                  </ListItem>
                )) }
              </InfiniteScroll>
            </List>
          </Grid>
        </Grid>
      );
    }else{
      return <p>ツイートが存在しません</p>;
    }
  }
}

export default TweetList;

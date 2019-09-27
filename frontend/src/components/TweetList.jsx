import React from "react";
import { withRouter } from "react-router-dom";
import shortid from "shortid";
import InfiniteScroll from "react-infinite-scroll-component";
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
  loadMore() {
    const { year, month, day } = this.props.match.params;
    const nextPage = this.props.page + 1;
    this.props.onLoadMoreTweetsFetchFunc(year, month, day, nextPage)
      .then( response => {
        this.props.appendTweets(response.data);
        this.props.setPage(nextPage);
      }).catch( error => {
        this.props.setHasMore(false);
        const statusCode = error.response.status;
        if(statusCode !== 404) {
          this.props.setApiErrorCode(statusCode);
        }
      });
  }

  componentDidMount() {
    this.props.resetPage();
    this.props.resetHasMore();
  }

  render() {
    return(
      <Grid container justify="center">
        <Grid item lg={ 8 }>
          <List>
            <InfiniteScroll
              dataLength={ this.props.tweets.length }
              next={ this.loadMore.bind(this) }
              hasMore={ this.props.hasMore }
              loader={ loader }
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
  }
}

export default withRouter(TweetList);

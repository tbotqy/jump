import React from "react";
import { withStyles } from "@material-ui/core/styles";
import { withRouter } from "react-router-dom";
import shortid from "shortid";
import InfiniteScroll from "react-infinite-scroll-component";
import {
  List,
  ListItem,
  Box,
  CircularProgress
} from "@material-ui/core";
import TweetCard from "./TweetCard";
import { API_ERROR_CODE_NOT_FOUND } from "../utils/api";

const styles = () => ({
  list: {
    width: "100%"
  }
});

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
  componentDidMount() {
    this.props.resetPage();
    this.props.resetHasMore();
  }

  render() {
    return(
      <List className={ this.props.classes.list }>
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
    );
  }

  async loadMore() {
    const { year, month, day } = this.props.match.params;
    const nextPage = this.props.page + 1;
    try {
      const response = await this.props.onLoadMoreTweetsFetchFunc({ year, month, day, page: nextPage });
      this.props.appendTweets(response.data);
      this.props.setPage(nextPage);
    } catch(error) {
      this.props.setHasMore(false);
      const statusCode = error.response.status;
      if(statusCode !== API_ERROR_CODE_NOT_FOUND) {
        this.props.setApiErrorCode(statusCode);
      }
    }
  }
}

export default withRouter(withStyles(styles)(TweetList));

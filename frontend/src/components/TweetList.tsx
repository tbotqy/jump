import React from "react";
import { withStyles } from "@material-ui/core/styles";
import { withRouter, RouteComponentProps } from "react-router-dom";
import shortid from "shortid";
import InfiniteScroll from "react-infinite-scroll-component";
import {
  List,
  ListItem,
  Box,
  CircularProgress,
  createStyles,
  WithStyles
} from "@material-ui/core";
import TweetCard from "./TweetCard";
import {
  PaginatableDateParams,
  DateParams,
  Tweet,
  UrlEntity,
  TweetUser
} from "../api";
import { AxiosPromise } from "axios";

const styles = createStyles({
  list: {
    width: "100%"
  }
});

interface TweetCardProps {
  tweetId: string;
  isRetweet: boolean;
  tweetedAt: string;
  user: TweetUser;
  urlEntities: UrlEntity[];
  name: string;
  screenName: string;
  avatarUrl: string;
  text: string;
}

const tweetCardPropsByTweet = (tweet: Tweet): TweetCardProps => {
  const ret = {
    tweetId:     tweet.tweetId,
    isRetweet:   tweet.isRetweet,
    tweetedAt:   tweet.tweetedAt,
    user:        tweet.user,
    urlEntities: tweet.urls
  };

  if(tweet.isRetweet) {
    return ({
      ...ret,
      name:       tweet.rtName,
      screenName: tweet.rtScreenName,
      avatarUrl:  tweet.rtAvatarUrl,
      text:       tweet.rtText
    });
  }else{
    return ({
      ...ret,
      name:       tweet.user.name,
      screenName: tweet.user.screenName,
      avatarUrl:  tweet.user.avatarUrl,
      text:       tweet.text
    });
  }
};

const loader = (
  <Box key={ shortid.generate() } display="flex" justifyContent="center" p={ 3 }>
    <CircularProgress />
  </Box>
);

interface Props extends RouteComponentProps<DateParams>, WithStyles<typeof styles> {
  appendTweets: (tweets: Tweet[]) => void;
  setApiErrorCode: (code: number) => void;
  onLoadMoreTweetsFetchFunc: ({ year, month, day, page }: PaginatableDateParams) => AxiosPromise;
  tweets: Tweet[];
}

interface State {
  page: number;
  hasMore: boolean;
}

class TweetList extends React.Component<Props, State> {
  private INITIAL_PAGE = 1
  private INITIAL_HAS_MORE = true

  state = {
    page: this.INITIAL_PAGE,
    hasMore: this.INITIAL_HAS_MORE
  }

  componentDidMount() {
    this.resetPageState();
  }

  componentDidUpdate(prevProps: Props) {
    if (this.props.match.url !== prevProps.match.url) {
      this.resetPageState();
    }
  }

  render() {
    return(
      <List className={ this.props.classes.list } component="section">
        <InfiniteScroll
          dataLength={ this.props.tweets.length }
          next={ this.loadMore.bind(this) }
          hasMore={ this.state.hasMore }
          loader={ loader }
        >
          { this.props.tweets.map( tweet => (
            <ListItem divider disableGutters key={ tweet.tweetId } component="article">
              <TweetCard { ...tweetCardPropsByTweet(tweet) } />
            </ListItem>
          )) }
        </InfiniteScroll>
      </List>
    );
  }

  async loadMore() {
    const { year, month, day } = this.props.match.params;
    const nextPage: number = this.state.page + 1;

    const response = await this.props.onLoadMoreTweetsFetchFunc({ year, month, day, page: nextPage } as PaginatableDateParams);
    const tweets = response.data;
    if (tweets.length > 0) {
      this.props.appendTweets(response.data);
      this.setState({page: nextPage});
    } else {
      this.setState({hasMore: false});
    }
  }

  resetPageState() {
    this.setState({
      page:    this.INITIAL_PAGE,
      hasMore: this.INITIAL_HAS_MORE
    });
  }
}

export default withRouter(withStyles(styles)(TweetList));

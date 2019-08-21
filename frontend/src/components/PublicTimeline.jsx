import React from "react";
import {
  Container,
  LinearProgress
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import HeadNav       from "./HeadNav";
import DateSelectors from "../containers/DateSelectorsContainer";
import TweetList     from "../containers/TweetListContainer";

const styles = theme => ({
  container: {
    paddingTop:   theme.spacing(3),
    paddingLeft:  theme.spacing(1),
    paddingRight: theme.spacing(1)
  },
  tweetListContainer: {
    minHeight: "100vh"
  }
});

class PublicTimeline extends React.Component {
  constructor(props) {
    super(props);
    this.props.setTimelineBasePath("/public_timeline/");
  }

  componentDidMount() {
    const { year, month, day } = this.props.match.params;
    this.fetchTweetsToReset(year, month, day);
    window.addEventListener("scroll", this.showMore.bind(this));
  }

  componentWillUnmount() {
    window.removeEventListener("scroll", this.showMore.bind(this));
  }

  render() {
    return(
      <>
        <HeadNav />
        <Container className={ this.props.classes.container }>
          <div className={ this.props.classes.tweetListContainer }>
            { this.props.isFetching ? <LinearProgress /> : <TweetList /> }
            { this.props.isFetchingMore && <LinearProgress /> }
          </div>
          { this.props.tweets.length > 0 && <DateSelectors selectableDatesFetcher={ this.props.fetchPublicSelectableDates } tweetsFetcher={ this.fetchTweetsToReset.bind(this) } /> }
        </Container>
      </>
    );
  }

  fetchTweetsToReset(year, month, day) {
    this.props.setIsFetching(true);
    this.props.fetchPublicTweets(year, month, day)
      .then( response => {
        this.props.setTweets(response.data);
        this.props.setCurrentPage(1);
        this.props.setNoMoreTweets(false);
      }).catch( () => {
        this.props.setNoMoreTweets(true);
      }).then( () => {
        this.props.setIsFetching(false);
      });
  }

  showMore() {
    const pageHeight     = document.body.clientHeight;
    const scrolledHeight = window.pageYOffset;
    const approachingToBottom = (pageHeight - scrolledHeight) <= 770;

    if( approachingToBottom && !this.props.noMoreTweets && !this.props.isFetching && !this.props.isFetchingMore ) {
      const { selectedYear, selectedMonth, selectedDay, currentPage } = this.props;
      const nextPage = currentPage + 1;
      this.props.setIsFetchingMore(true);
      this.props.fetchPublicTweets(selectedYear, selectedMonth, selectedDay, nextPage)
        .then( response => {
          this.props.appendTweets(response.data);
          this.props.setCurrentPage(nextPage);
        }).catch( error => {
          switch(error.response.status) {
          case 404:
            this.props.setNoMoreTweets(true);
            break;
          default:
            alert("error!"); // TODO: implement
          }
        }).then( this.props.setIsFetchingMore(false) );
    }
  }
}

export default withStyles(styles)(PublicTimeline);

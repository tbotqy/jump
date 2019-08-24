import React from "react";
import {
  Container,
  LinearProgress
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import HeadNav       from "./HeadNav";
import DateSelectors from "../containers/DateSelectorsContainer";
import TweetList     from "../containers/TweetListContainer";
import Error         from "./Error";

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
  }

  content() {
    if(this.props.apiErrorCode) {
      return <Error apiErrorCode={ this.props.apiErrorCode } />;
    }else{
      return(
        <>
          <div className={ this.props.classes.tweetListContainer }>
            { this.props.isFetching ? <LinearProgress /> : <TweetList tweetsFetcher={ this.props.fetchPublicTweets } /> }
          </div>
          { this.props.tweets.length > 0 && <DateSelectors selectableDatesFetcher={ this.props.fetchPublicSelectableDates } tweetsFetcher={ this.fetchTweetsToReset.bind(this) } /> }
        </>
      );
    }
  }

  render() {
    return(
      <>
        <HeadNav />
        <Container className={ this.props.classes.container }>
          { this.content() }
        </Container>
      </>
    );
  }

  fetchTweetsToReset(year, month, day) {
    this.props.setIsFetching(true);
    this.props.fetchPublicTweets(year, month, day)
      .then( response => {
        this.props.setTweets(response.data);
      }).catch( error => {
        this.props.setApiErrorCode(error.response.status);
      }).then( () => {
        this.props.setIsFetching(false);
      });
  }
}

export default withStyles(styles)(PublicTimeline);

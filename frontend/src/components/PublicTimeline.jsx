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
    this.props.fetchPublicTweets(year, month, day);
  }

  render() {
    return(
      <>
        <HeadNav />
        <Container className={ this.props.classes.container }>
          <div className={ this.props.classes.tweetListContainer }>
            { this.props.fetchingTweets ? <LinearProgress /> : <TweetList tweets={ this.props.tweets } /> }
          </div>
          <DateSelectors selectableDatesFetcher={ this.props.fetchPublicSelectableDates } tweetsFetcher={ this.props.fetchPublicTweets } />
        </Container>
      </>
    );
  }
}

export default withStyles(styles)(PublicTimeline);

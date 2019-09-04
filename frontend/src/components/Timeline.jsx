import React from "react";
import { withRouter } from "react-router-dom";
import {
  Container,
  LinearProgress
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import scrollToTop   from "./../utils/scrollToTop";
import HeadNav       from "../containers/HeadNavContainer";
import DateSelectors from "../containers/DateSelectorsContainer";
import TweetList     from "../containers/TweetListContainer";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";

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

class Timeline extends React.Component {
  constructor(props) {
    super(props);

    this.onPopStateFunc = this.onBackOrForwardButtonEvent.bind(this);
    window.addEventListener("popstate", this.onPopStateFunc);
  }

  onBackOrForwardButtonEvent(e) {
    e.preventDefault();
    const { year, month, day } = this.props.match.params;
    this.props.setIsFetching(true);
    this.props.tweetsFetchFunc(year, month, day)
      .then( response => {
        this.props.setTweets(response.data);
      }).catch( error => {
        this.props.setApiErrorCode(error.response.status);
      }).finally( () => {
        this.props.setIsFetching(false);
      });
    scrollToTop();
  }

  render() {
    return(
      <>
        <HeadNav />
        <Container className={ this.props.classes.container }>
          <ApiErrorBoundary>
            <div className={ this.props.classes.tweetListContainer }>
              { this.props.isFetching ? <LinearProgress /> : <TweetList onLoadMoreTweetsFetchFunc={ this.props.tweetsFetchFunc } /> }
            </div>
            { this.props.selectableDates.length > 0 && <DateSelectors selectableDates={ this.props.selectableDates } onSelectionChangeTweetsFetchFunc={ this.props.tweetsFetchFunc } /> }
          </ApiErrorBoundary>
        </Container>
      </>
    );
  }

  componentWillUnmount() {
    window.removeEventListener("popstate", this.onPopStateFunc);
  }
}

export default withRouter(withStyles(styles)(Timeline));

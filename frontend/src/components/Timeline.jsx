import React from "react";
import { withRouter } from "react-router-dom";
import {
  Container,
  LinearProgress
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import scrollToTop   from "./../utils/scrollToTop";
import Ad            from "./Ad";
import DateSelectors from "../containers/DateSelectorsContainer";
import TweetList     from "../containers/TweetListContainer";

const styles = theme => ({
  container: {
    paddingTop:   theme.spacing(3),
    paddingLeft:  theme.spacing(1),
    paddingRight: theme.spacing(1)
  },
  adWrapper: {
    paddingBottom: theme.spacing(3),
    textAlign: "center"
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

  render() {
    return(
      <Container className={ this.props.classes.container }>
        <div className={ this.props.classes.adWrapper }>
          <Ad slot={ process.env.REACT_APP_AD_SLOT_ABOVE_TWEETS } />
        </div>
        <div className={ this.props.classes.tweetListContainer }>
          { this.props.isFetching ? <LinearProgress /> : <TweetList onLoadMoreTweetsFetchFunc={ this.props.tweetsFetchFunc } /> }
        </div>
        { this.props.selectableDates.length > 0 && <DateSelectors selectableDates={ this.props.selectableDates } onSelectionChangeTweetsFetchFunc={ this.props.tweetsFetchFunc } /> }
      </Container>
    );
  }

  componentWillUnmount() {
    window.removeEventListener("popstate", this.onPopStateFunc);
  }

  async onBackOrForwardButtonEvent(e) {
    e.preventDefault();
    const { year, month, day } = this.props.match.params;
    this.props.setIsFetching(true);
    try {
      const response = await this.props.tweetsFetchFunc(year, month, day);
      this.props.setTweets(response.data);
    } catch(error) {
      this.props.setApiErrorCode(error.response.status);
    } finally {
      this.props.setIsFetching(false);
    }
    scrollToTop();
  }
}

export default withRouter(withStyles(styles)(Timeline));

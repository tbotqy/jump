import React from "react";
import { withRouter } from "react-router-dom";
import { withStyles } from "@material-ui/core/styles";
import {
  Container,
  Box,
  Grid,
  Typography
} from "@material-ui/core";
import Head from "./Head";
import HeadNav from "../containers/HeadNavContainer";
import HeadProgressBar from "../containers/HeadProgressBarContainer";
import DateSelectors from "../containers/DateSelectorsContainer";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";
import timelineTitleText from "../utils/timelineTitleText";
import scrollToTop   from "./../utils/scrollToTop";
import Ad            from "./Ad";
import timelinePageHeaderText from "../utils/timelinePageHeaderText";
import TweetList     from "../containers/TweetListContainer";
import TweetButton from "./TweetButton";


const styles = theme => ({
  container: {
    paddingTop:   theme.spacing(3),
    paddingLeft:  theme.spacing(2),
    paddingRight: theme.spacing(2)
  },
  dateSelectorContainer: {
    position: "sticky",
    bottom: theme.spacing(3)
  },
  tweetListContainer: {
    minHeight: "100vh"
  }
});

class TimelineBase extends React.Component {
  constructor(props) {
    super(props);
    this.state = { selectableDates: [] };

    this.onPopStateFunc = this.onBackOrForwardButtonEvent.bind(this);
    window.addEventListener("popstate", this.onPopStateFunc);
  }

  componentDidMount() {
    this.setState({ selectableDates: [] });
    const { year, month, day } = this.props.match.params;
    this.fetchTweets(year, month, day);
    this.fetchSelectableDates();
  }

  render() {
    return (
      <>
        <Head title={ this.title() } />
        <HeadNav />
        <ApiErrorBoundary>
          <HeadProgressBar />
          <Container maxWidth="md" className={ this.props.classes.container }>
            <Grid container justify="space-between">
              <Grid item>
                { this.headerText() }
              </Grid>
              <Grid item>
                { this.props.showTweetButton && <TweetButton text={ document.title } buttonText={ "共有" } inTwitterBrandColor /> }
              </Grid>
            </Grid>
            <Container>
              <Ad slot={ process.env.REACT_APP_AD_SLOT_ABOVE_TWEETS } />
            </Container>
            <Grid container item justify="center" className={ this.props.classes.tweetListContainer }>
              { !this.props.isFetching && <TweetList onLoadMoreTweetsFetchFunc={ this.props.tweetsFetchFunc } /> }
            </Grid>
          </Container>
          { this.state.selectableDates.length > 0 &&
            <Box pr={ 2 } className={ this.props.classes.dateSelectorContainer }>
              <DateSelectors
                selectableDates={ this.state.selectableDates }
                onSelectionChangeTweetsFetchFunc={ this.props.tweetsFetchFunc }
              />
            </Box>
          }
        </ApiErrorBoundary>
      </>
    );
  }

  componentWillUnmount() {
    window.removeEventListener("popstate", this.onPopStateFunc);
  }

  async onBackOrForwardButtonEvent(e) {
    e.preventDefault();
    const { year, month, day } = this.props.match.params;
    this.fetchTweets(year, month, day);
    scrollToTop();
  }

  async fetchTweets(year, month, day) {
    this.props.setIsFetching(true);
    try {
      const response = await this.props.tweetsFetchFunc(year, month, day);
      this.props.setTweets(response.data);
    } catch(error) {
      error.response && this.props.setApiErrorCode(error.response.status);
    } finally{
      this.props.setIsFetching(false);
    }
  }

  async fetchSelectableDates() {
    try {
      const response = await this.props.selectableDatesFetchFunc();
      this.setState({ selectableDates: response.data });
    } catch(error) {
      error.response && this.props.setApiErrorCode(error.response.status);
    }
  }

  // TODO: consider to be given as param
  title() {
    const { year, month, day } = this.props.match.params;
    return timelineTitleText(this.props.timelineName, year, month, day);
  }

  headerText() {
    const { selectedYear, selectedMonth, selectedDay } = this.props;
    const { screenName } = this.props.match.params;
    if( selectedYear && selectedMonth && selectedDay ) {
      return (
        <Typography component="h1" variant="h5" color="textSecondary">
          { timelinePageHeaderText(selectedYear, selectedMonth, selectedDay, screenName) }
        </Typography>
      );
    } else {
      return <></>;
    }
  }
}

export default withRouter(withStyles(styles)(TimelineBase));

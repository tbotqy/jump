import React from "react";
import { withRouter } from "react-router-dom";
import {
  Container,
  Grid,
  Typography,
  Box
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import scrollToTop   from "./../utils/scrollToTop";
import Ad            from "./Ad";
import DateSelectors from "../containers/DateSelectorsContainer";
import TweetList     from "../containers/TweetListContainer";
import timelinePageHeaderText from "../utils/timelinePageHeaderText";

const styles = theme => ({
  container: {
    paddingTop:   theme.spacing(3),
    paddingLeft:  theme.spacing(2),
    paddingRight: theme.spacing(2)
  },
  adWrapper: {
    paddingTop:    theme.spacing(3),
    paddingBottom: theme.spacing(3),
    textAlign: "center"
  },
  tweetListContainer: {
    minHeight: "100vh"
  },
  dateSelectorContainer: {
    position: "sticky",
    bottom: theme.spacing(3)
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
      <>
        <Container maxWidth="md" className={ this.props.classes.container }>
          <Grid container item justify="flex-start">
            { this.headerText() }
          </Grid>
          <Container>
            <Ad slot={ process.env.REACT_APP_AD_SLOT_ABOVE_TWEETS } />
          </Container>
          <Grid container item justify="center" className={ this.props.classes.tweetListContainer }>
            { !this.props.isFetching && <TweetList onLoadMoreTweetsFetchFunc={ this.props.tweetsFetchFunc } /> }
          </Grid>
        </Container>
        <Box pr={ 2 } className={ this.props.classes.dateSelectorContainer }>
          { this.props.selectableDates.length > 0 && <DateSelectors selectableDates={ this.props.selectableDates } onSelectionChangeTweetsFetchFunc={ this.props.tweetsFetchFunc } /> }
        </Box>
      </>
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

export default withRouter(withStyles(styles)(Timeline));

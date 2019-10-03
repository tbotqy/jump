import React from "react";
import { withRouter } from "react-router-dom";
import { withStyles } from "@material-ui/core/styles";
import {
  Container,
  Box
} from "@material-ui/core";
import Timeline from "../containers/TimelineContainer";
import HeadNav from "../containers/HeadNavContainer";
import HeadProgressBar from "../containers/HeadProgressBarContainer";
import DateSelectors from "../containers/DateSelectorsContainer";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";

const styles = theme => ({
  container: {
    paddingTop:   theme.spacing(3),
    paddingLeft:  theme.spacing(2),
    paddingRight: theme.spacing(2)
  },
  dateSelectorContainer: {
    position: "sticky",
    bottom: theme.spacing(3)
  }
});

class TimelineBase extends React.Component {
  constructor(props) {
    super(props);
    this.state = { selectableDates: [] };
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
        <HeadNav />
        <ApiErrorBoundary>
          <HeadProgressBar />
          <Container maxWidth="md" className={ this.props.classes.container }>
            <Timeline tweetsFetchFunc={ this.props.tweetsFetchFunc } />
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
}

export default withRouter(withStyles(styles)(TimelineBase));

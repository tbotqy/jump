import React from "react";
import {
  fetchFolloweeTweets,
  fetchFolloweeSelectableDates
} from "../utils/api";
import timelineTitleText from "../utils/timelineTitleText";
import Timeline from "../containers/TimelineContainer";
import Head from "./Head";
import HeadNav from "../containers/HeadNavContainer";
import HeadProgressBar from "../containers/HeadProgressBarContainer";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";

class HomeTimeline extends React.Component {
  componentDidMount() {
    this.props.setSelectableDates([]);
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
          <Timeline tweetsFetchFunc={ fetchFolloweeTweets.bind(this) } />
        </ApiErrorBoundary>
      </>
    );
  }

  async fetchTweets(year, month, day) {
    this.props.setIsFetching(true);
    try {
      const response = await fetchFolloweeTweets(year, month, day);
      this.props.setTweets(response.data);
    } catch(error) {
      this.props.setApiErrorCode(error.response.status);
    } finally {
      this.props.setIsFetching(false);
    }
  }

  async fetchSelectableDates() {
    try {
      const response = await fetchFolloweeSelectableDates();
      this.props.setSelectableDates(response.data);
    } catch(error) {
      this.props.setApiErrorCode(error.response.status);
    }
  }

  title() {
    const { year, month, day } = this.props.match.params;
    return timelineTitleText("ホームタイムライン", year, month, day);
  }
}

export default HomeTimeline;

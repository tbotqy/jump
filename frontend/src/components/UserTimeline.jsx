import React from "react";
import {
  fetchUserTweets,
  fetchUserSelectableDates
} from "../utils/api";
import timelineTitleText from "../utils/timelineTitleText";
import Timeline from "../containers/TimelineContainer";
import Head from "./Head";
import HeadNav from "../containers/HeadNavContainer";
import HeadProgressBar from "../containers/HeadProgressBarContainer";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";

class UserTimeline extends React.Component {
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
          <Timeline tweetsFetchFunc={ fetchUserTweets.bind(this) } />
        </ApiErrorBoundary>
      </>
    );
  }

  async fetchTweets(year, month, day) {
    this.props.setIsFetching(true);
    try {
      const response = await fetchUserTweets(year, month, day);
      this.props.setTweets(response.data);
    } catch(error) {
      this.props.setApiErrorCode(error.response.status);
    } finally {
      this.props.setIsFetching(false);
    }
  }

  async fetchSelectableDates() {
    try {
      const response = await fetchUserSelectableDates();
      this.props.setSelectableDates(response.data);
    } catch(error) {
      this.props.setApiErrorCode(error.response.status);
    }
  }

  title() {
    const { year, month, day } = this.props.match.params;
    return timelineTitleText("ユーザータイムライン", year, month, day);
  }
}

export default UserTimeline;

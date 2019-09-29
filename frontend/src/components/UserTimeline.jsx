import React from "react";
import {
  fetchUserTweets,
  fetchUserSelectableDates
} from "../utils/api";
import timelineTitleText from "../utils/timelineTitleText";
import Timeline from "../containers/TimelineContainer";
import Head from "./Head";

class UserTimeline extends React.Component {
  componentDidMount() {
    this.props.setSelectableDates([]);
    const { year, month, day } = this.props.match.params;
    this.fetchTweets(year, month, day);
    this.fetchSelectableDates(year, month, day);
  }

  render() {
    return (
      <>
        <Head title={ this.title() } />
        <Timeline tweetsFetchFunc={ fetchUserTweets.bind(this) } />
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

  async fetchSelectableDates(year, month, day) {
    try {
      const response = await fetchUserSelectableDates(year, month, day);
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

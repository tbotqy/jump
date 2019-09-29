import React from "react";
import {
  fetchPublicTweets,
  fetchPublicSelectableDates
} from "../utils/api";
import timelineTitleText from "../utils/timelineTitleText";
import Timeline from "../containers/TimelineContainer";
import Head from "./Head";

class PublicTimeline extends React.Component {
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
        <Timeline tweetsFetchFunc={ fetchPublicTweets.bind(this) } />
      </>
    );
  }

  async fetchTweets(year, month, day) {
    this.props.setIsFetching(true);
    try {
      const response = await fetchPublicTweets(year, month, day);
      this.props.setTweets(response.data);
    } catch(error) {
      this.props.setApiErrorCode(error.response.status);
    } finally{
      this.props.setIsFetching(false);
    }
  }

  async fetchSelectableDates(year, month, day) {
    try {
      const response = await fetchPublicSelectableDates(year, month, day);
      this.props.setSelectableDates(response.data);
    } catch(error) {
      this.props.setApiErrorCode(error.response.status);
    }
  }

  title() {
    const { year, month, day } = this.props.match.params;
    return timelineTitleText("パブリックタイムライン", year, month, day);
  }
}

export default PublicTimeline;

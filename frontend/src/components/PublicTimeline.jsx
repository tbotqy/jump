import React from "react";
import {
  fetchPublicTweets,
  fetchPublicSelectableDates
} from "../utils/api";
import timelineTitleText from "../utils/timelineTitleText";
import Timeline from "../containers/TimelineContainer";
import Head from "./Head";

class PublicTimeline extends React.Component {
  fetchTweets(year, month, day) {
    this.props.setIsFetching(true);
    fetchPublicTweets(year, month, day)
      .then( response => this.props.setTweets(response.data) )
      .catch( error => this.props.setApiErrorCode(error.response.status) )
      .finally( () => this.props.setIsFetching(false) );
  }

  fetchSelectableDates(year, month, day) {
    fetchPublicSelectableDates(year, month, day)
      .then( response => this.props.setSelectableDates(response.data) )
      .catch( error => this.props.setApiErrorCode(error.response.status) );
  }

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

  title() {
    const { year, month, day } = this.props.match.params;
    return timelineTitleText("パブリックタイムライン", year, month, day);
  }
}

export default PublicTimeline;

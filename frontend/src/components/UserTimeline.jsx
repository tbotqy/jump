import React from "react";
import {
  fetchUserTweets,
  fetchUserSelectableDates
} from "../utils/api";
import timelineTitleText from "../utils/timelineTitleText";
import Timeline from "../containers/TimelineContainer";
import Head from "./Head";

class UserTimeline extends React.Component {
  fetchTweets(year, month, day) {
    this.props.setIsFetching(true);
    fetchUserTweets(year, month, day)
      .then( response => this.props.setTweets(response.data) )
      .catch( error => this.props.setApiErrorCode(error.response.status) )
      .finally( () => this.props.setIsFetching(false) );
  }

  fetchSelectableDates(year, month, day) {
    fetchUserSelectableDates(year, month, day)
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
        <Timeline tweetsFetchFunc={ fetchUserTweets.bind(this) } />
      </>
    );
  }

  title() {
    const { year, month, day } = this.props.match.params;
    return timelineTitleText("ユーザータイムライン", year, month, day);
  }
}

export default UserTimeline;

import React from "react";
import {
  fetchFolloweeTweets,
  fetchFolloweeSelectableDates
} from "../utils/api";
import timelineTitleText from "../utils/timelineTitleText";
import Timeline from "../containers/TimelineContainer";

class HomeTimeline extends React.Component {
  fetchTweets(year, month, day) {
    this.props.setIsFetching(true);
    fetchFolloweeTweets(year, month, day)
      .then( response => this.props.setTweets(response.data) )
      .catch( error => this.props.setApiErrorCode(error.response.status) )
      .finally( () => this.props.setIsFetching(false) );
  }

  fetchSelectableDates(year, month, day) {
    fetchFolloweeSelectableDates(year, month, day)
      .then( response => this.props.setSelectableDates(response.data) )
      .catch( error => this.props.setApiErrorCode(error.response.status) );
  }

  componentDidMount() {
    this.props.setSelectableDates([]);
    const { year, month, day } = this.props.match.params;
    this.fetchTweets(year, month, day);
    this.fetchSelectableDates(year, month, day);
    document.title = timelineTitleText("ホームタイムライン", year, month, day);
  }

  render() {
    return <Timeline tweetsFetchFunc={ fetchFolloweeTweets.bind(this) } />;
  }
}

export default HomeTimeline;

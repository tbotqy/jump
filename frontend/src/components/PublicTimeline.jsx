import React from "react";
import {
  fetchPublicTweets,
  fetchPublicSelectableDates
} from "../utils/api";
import timelineTitleText from "../utils/timelineTitleText";
import Timeline from "../containers/TimelineContainer";

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
    document.title = timelineTitleText("パブリックタイムライン", year, month, day);
  }

  render() {
    return <Timeline tweetsFetchFunc={ fetchPublicTweets.bind(this) } />;
  }
}

export default PublicTimeline;

import React from "react";
import Timeline from "../containers/TimelineContainer";

class PublicTimeline extends React.Component {
  fetchTweets(year, month, day) {
    this.props.setIsFetching(true);
    this.props.fetchPublicTweets(year, month, day)
      .then( response => this.props.setTweets(response.data) )
      .catch( error => this.props.setApiErrorCode(error.response.status) )
      .finally( () => this.props.setIsFetching(false) );
  }

  fetchSelectableDates(year, month, day) {
    this.props.fetchPublicSelectableDates(year, month, day)
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
    return <Timeline tweetsFetchFunc={ this.props.fetchPublicTweets.bind(this) } />;
  }
}

export default PublicTimeline;

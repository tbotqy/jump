import React from "react";
import Timeline from "../containers/TimelineContainer";

class UserTimeline extends React.Component {
  fetchTweets(year, month, day) {
    this.props.setIsFetching(true);
    this.props.fetchUserTweets(year, month, day)
      .then( response => this.props.setTweets(response.data) )
      .catch( error => this.props.setApiErrorCode(error.response.status) )
      .finally( () => this.props.setIsFetching(false) );
  }

  fetchSelectableDates(year, month, day) {
    this.props.fetchUserSelectableDates(year, month, day)
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
    return <Timeline tweetsFetchFunc={ this.props.fetchUserTweets.bind(this) } />;
  }
}

export default UserTimeline;

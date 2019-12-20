import React from "react";
import {
  fetchUserTweets,
  fetchUserSelectableDates
} from "../api";
import TimelineBase from "../containers/TimelineBaseContainer";

const UserTimeline: React.FC = () => (
  <TimelineBase
    tweetsFetchFunc={ fetchUserTweets }
    selectableDatesFetchFunc={ fetchUserSelectableDates }
    timelineName={ "ユーザータイムライン" }
  />
);

export default UserTimeline;

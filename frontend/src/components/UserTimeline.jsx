import React from "react";
import {
  fetchUserTweets,
  fetchUserSelectableDates
} from "../utils/api";
import TimelineBase from "../containers/TimelineBaseContainer";

const UserTimeline = () => (
  <TimelineBase
    tweetsFetchFunc={ fetchUserTweets }
    selectableDatesFetchFunc={ fetchUserSelectableDates }
    timelineName={ "ユーザータイムライン" }
  />
);

export default UserTimeline;

import React from "react";
import {
  fetchMeTweets,
  fetchMeSelectableDates
} from "../api";
import TimelineBase from "../containers/TimelineBaseContainer";

const UserTimeline: React.FC = () => (
  <TimelineBase
    tweetsFetchFunc={ fetchMeTweets }
    selectableDatesFetchFunc={ fetchMeSelectableDates }
    timelineName={ "ユーザータイムライン" }
  />
);

export default UserTimeline;

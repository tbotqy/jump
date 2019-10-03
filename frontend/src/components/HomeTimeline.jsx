import React from "react";
import {
  fetchFolloweeTweets,
  fetchFolloweeSelectableDates
} from "../utils/api";
import TimelineBase from "../containers/TimelineBaseContainer";

const HomeTimeline = () => (
  <TimelineBase
    tweetsFetchFunc={ fetchFolloweeTweets }
    selectableDatesFetchFunc={ fetchFolloweeSelectableDates }
    timelineName={ "ホームタイムライン" }
  />
);

export default HomeTimeline;

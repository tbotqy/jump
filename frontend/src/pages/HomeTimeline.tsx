import React from "react";
import {
  fetchMeFolloweeTweets,
  fetchMeFolloweeSelectableDates
} from "../api";
import TimelineBase from "../containers/TimelineBaseContainer";

const HomeTimeline: React.FC = () => (
  <TimelineBase
    tweetsFetchFunc={fetchMeFolloweeTweets}
    selectableDatesFetchFunc={fetchMeFolloweeSelectableDates}
    timelineName={"ホームタイムライン"}
  />
);

export default HomeTimeline;

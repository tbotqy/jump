import React from "react";
import {
  fetchMeFolloweeTweets,
  fetchMeFolloweeSelectableDates
} from "../api";
import TimelineBase from "../containers/TimelineBaseContainer";
import { HOME_TIMELINE_PATH } from "../utils/paths";

const HomeTimeline: React.FC = () => (
  <TimelineBase
    tweetsFetchFunc={fetchMeFolloweeTweets}
    selectableDatesFetchFunc={fetchMeFolloweeSelectableDates}
    basePath={HOME_TIMELINE_PATH}
    timelineName={"ホームタイムライン"}
  />
);

export default HomeTimeline;

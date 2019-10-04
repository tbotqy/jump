import React from "react";
import {
  fetchPublicTweets,
  fetchPublicSelectableDates
} from "../utils/api";
import TimelineBase from "../containers/TimelineBaseContainer";

const PublicTimeline = () => (
  <TimelineBase
    tweetsFetchFunc={ fetchPublicTweets }
    selectableDatesFetchFunc={ fetchPublicSelectableDates }
    timelineName={ "パブリックタイムライン" }
    showTweetButton
  />
);

export default PublicTimeline;

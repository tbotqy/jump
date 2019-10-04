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
    timelineName={ "パブリックタイムライン" } // TODO: rename param name
    showTweetButton
  />
);

export default PublicTimeline;

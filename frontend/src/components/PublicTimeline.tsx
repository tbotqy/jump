import React from "react";
import {
  fetchPublicTweets,
  fetchPublicSelectableDates
} from "../api";
import TimelineBase from "../containers/TimelineBaseContainer";

const PublicTimeline: React.FC = () => (
  <TimelineBase
    tweetsFetchFunc={ fetchPublicTweets }
    selectableDatesFetchFunc={ fetchPublicSelectableDates }
    timelineName={ "パブリックタイムライン" } // TODO: rename param name
    showTweetButton
  />
);

export default PublicTimeline;

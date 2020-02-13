import React from "react";
import {
  fetchPublicTweets,
  fetchPublicSelectableDates
} from "../api";
import TimelineBase from "../containers/TimelineBaseContainer";
import { PUBLIC_TIMELINE_PATH } from "../utils/paths";

const PublicTimeline: React.FC = () => (
  <TimelineBase
    tweetsFetchFunc={fetchPublicTweets}
    selectableDatesFetchFunc={fetchPublicSelectableDates}
    timelineName={"パブリックタイムライン"} // TODO: rename param name
    showShareButton
  />
);

export default PublicTimeline;

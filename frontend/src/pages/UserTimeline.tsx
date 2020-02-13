import React from "react";
import {
  fetchMeTweets,
  fetchMeSelectableDates
} from "../api";
import TimelineBase from "../containers/TimelineBaseContainer";
import { USER_TIMELINE_PATH } from "../utils/paths";

const UserTimeline: React.FC = () => (
  <TimelineBase
    tweetsFetchFunc={fetchMeTweets}
    selectableDatesFetchFunc={fetchMeSelectableDates}
    timelineName={"ユーザータイムライン"}
    basePath={USER_TIMELINE_PATH}
  />
);

export default UserTimeline;

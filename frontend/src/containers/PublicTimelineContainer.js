import { connect } from "react-redux";
import {
  fetchPublicTweets,
  setTweets,
  setIsFetching
} from "../actions/tweetsActions";
import { fetchPublicSelectableDates } from "../actions/selectableDatesActions";
import { setTimelineBasePath } from "../actions/timelineActions";
import PublicTimeline from "../components/PublicTimeline";

const mapStateToProps = state => ({
  tweets:     state.tweets.tweets,
  isFetching: state.tweets.isFetching
});

const mapDispatchToProps = dispatch => ({
  fetchPublicTweets:          (year, month, day, page) => dispatch(fetchPublicTweets(year, month, day, page)),
  setIsFetching:              flag => dispatch(setIsFetching(flag)),
  setTweets:                  tweets => dispatch(setTweets(tweets)),
  fetchPublicSelectableDates: () => dispatch(fetchPublicSelectableDates()),
  setTimelineBasePath:        path => dispatch(setTimelineBasePath(path))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(PublicTimeline);

import { connect } from "react-redux";
import { fetchPublicTweets } from "../actions/tweetsActions";
import { fetchPublicSelectableDates } from "../actions/selectableDatesActions";
import { setTimelineBasePath } from "../actions/timelinePathActions";
import PublicTimeline from "../components/PublicTimeline";

const mapStateToProps = state => ({
  tweets:                  state.tweets.tweets,
  selectableDates:         state.selectableDates.selectableDates,
  fetchingTweets:          state.tweets.isFetching,
  fetchingSelectableDates: state.selectableDates.isFetching
});

const mapDispatchToProps = dispatch => ({
  fetchPublicTweets: (year, month, day) => dispatch(fetchPublicTweets(year, month, day)),
  fetchPublicSelectableDates: () => dispatch(fetchPublicSelectableDates()),
  setTimelineBasePath: path  => dispatch(setTimelineBasePath(path))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(PublicTimeline);

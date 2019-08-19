import { connect } from "react-redux";
import { fetchPublicTweets } from "../actions/tweetsActions";
import { fetchPublicSelectableDates } from "../actions/selectableDatesActions";
import PublicTimeline from "../components/PublicTimeline";

const mapStateToProps = state => ({
  tweets:                  state.tweets.tweets,
  selectableDates:         state.selectableDates.selectableDates,
  fetchingTweets:          state.tweets.isFetching,
  fetchingSelectableDates: state.selectableDates.isFetching
});

const mapDispatchToProps = dispatch => ({
  fetchPublicTweets: (year, month, day) => dispatch(fetchPublicTweets(year, month, day)),
  fetchPublicSelectableDates: () => dispatch(fetchPublicSelectableDates())
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(PublicTimeline);

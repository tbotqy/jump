import { connect } from "react-redux";
import {
  fetchPublicTweets,
  setTweets,
  setIsFetching
} from "../actions/tweetsActions";
import { fetchPublicSelectableDates } from "../actions/selectableDatesActions";
import { setTimelineBasePath } from "../actions/timelineActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import PublicTimeline from "../components/PublicTimeline";

const mapStateToProps = state => ({
  tweets:       state.tweets.tweets,
  isFetching:   state.tweets.isFetching,
  apiErrorCode: state.apiError.code
});

const mapDispatchToProps = dispatch => ({
  fetchPublicTweets:          (year, month, day, page) => dispatch(fetchPublicTweets(year, month, day, page)),
  setIsFetching:              flag => dispatch(setIsFetching(flag)),
  setTweets:                  tweets => dispatch(setTweets(tweets)),
  fetchPublicSelectableDates: () => dispatch(fetchPublicSelectableDates()),
  setTimelineBasePath:        path => dispatch(setTimelineBasePath(path)),
  setApiErrorCode:            code => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(PublicTimeline);

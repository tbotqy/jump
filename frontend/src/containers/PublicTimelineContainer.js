import { connect } from "react-redux";
import {
  fetchPublicTweets,
  setTweets,
  appendTweets,
  setIsFetching,
  setIsFetchingMore
} from "../actions/tweetsActions";
import { fetchPublicSelectableDates } from "../actions/selectableDatesActions";
import {
  setTimelineBasePath,
  setCurrentPage,
  setNoMoreTweets
} from "../actions/timelineActions";
import PublicTimeline from "../components/PublicTimeline";

const mapStateToProps = state => ({
  tweets:                  state.tweets.tweets,
  isFetching:              state.tweets.isFetching,
  isFetchingMore:          state.tweets.isFetchingMore,
  selectableDates:         state.selectableDates.selectableDates,
  fetchingSelectableDates: state.selectableDates.isFetching,
  selectedYear:            state.selectableDates.selectedYear,
  selectedMonth:           state.selectableDates.selectedMonth,
  selectedDay:             state.selectableDates.selectedDay,
  currentPage:             state.timeline.currentPage,
  noMoreTweets:            state.timeline.noMoreTweets
});

const mapDispatchToProps = dispatch => ({
  fetchPublicTweets:          (year, month, day, page) => dispatch(fetchPublicTweets(year, month, day, page)),
  setIsFetching:              flag => dispatch(setIsFetching(flag)),
  setIsFetchingMore:          flag => dispatch(setIsFetchingMore(flag)),
  setTweets:                  tweets => dispatch(setTweets(tweets)),
  appendTweets:               tweets => dispatch(appendTweets(tweets)),
  fetchPublicSelectableDates: () => dispatch(fetchPublicSelectableDates()),
  setTimelineBasePath:        path => dispatch(setTimelineBasePath(path)),
  setCurrentPage:             page => dispatch(setCurrentPage(page)),
  setNoMoreTweets:            flag => dispatch(setNoMoreTweets(flag))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(PublicTimeline);

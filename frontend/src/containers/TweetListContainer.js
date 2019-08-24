import { connect } from "react-redux";
import {
  appendTweets,
  setHasMore
} from "../actions/tweetsActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import TweetList from "../components/TweetList";

const mapStateToProps = state => ({
  tweets:        state.tweets.tweets,
  hasMore:       state.tweets.hasMore,
  selectedYear:  state.selectableDates.selectedYear,
  selectedMonth: state.selectableDates.selectedMonth,
  selectedDay:   state.selectableDates.selectedDay
});

const mapDispatchToProps = dispatch => ({
  appendTweets: tweets => dispatch(appendTweets(tweets)),
  setHasMore:   flag => dispatch(setHasMore(flag)),
  setApiErrorCode: code => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(TweetList);

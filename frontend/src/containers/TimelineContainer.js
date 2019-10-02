import { connect } from "react-redux";
import {
  setTweets,
  setIsFetching
} from "../actions/tweetsActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import Timeline from "../components/Timeline";

const mapStateToProps = state => ({
  tweets:          state.tweets.tweets,
  isFetching:      state.tweets.isFetching,
  selectableDates: state.selectableDates.selectableDates,
  selectedYear:    state.selectableDates.selectedYear,
  selectedMonth:   state.selectableDates.selectedMonth,
  selectedDay:     state.selectableDates.selectedDay
});

const mapDispatchToProps = dispatch => ({
  setIsFetching:   flag   => dispatch(setIsFetching(flag)),
  setTweets:       tweets => dispatch(setTweets(tweets)),
  setApiErrorCode: code   => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Timeline);

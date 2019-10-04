import { connect } from "react-redux";
import {
  setTweets,
  setIsFetching
} from "../actions/tweetsActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import TimelineBase from "../components/TimelineBase";

const mapStateToProps = state => ({
  isFetching:    state.tweets.isFetching,
  selectedYear:  state.selectableDates.selectedYear,
  selectedMonth: state.selectableDates.selectedMonth,
  selectedDay:   state.selectableDates.selectedDay
});

const mapDispatchToProps = dispatch => ({
  setTweets:       tweets => dispatch(setTweets(tweets)),
  setIsFetching:   flag => dispatch(setIsFetching(flag)),
  setApiErrorCode: code => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(TimelineBase);

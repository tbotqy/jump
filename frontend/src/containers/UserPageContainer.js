import { connect } from "react-redux";
import {
  setTweets,
  setIsFetching
} from "../actions/tweetsActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import UserPage from "../components/UserPage";

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
)(UserPage);

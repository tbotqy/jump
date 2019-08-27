import { connect } from "react-redux";
import {
  setTweets,
  setIsFetching,
  fetchUserTweets
} from "../actions/tweetsActions";
import {
  setSelectableDates,
  fetchUserSelectableDates
} from "../actions/selectableDatesActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import UserTimeline from "../components/UserTimeline";

const mapDispatchToProps = dispatch => ({
  setTweets:                tweets => dispatch(setTweets(tweets)),
  setIsFetching:            flag => dispatch(setIsFetching(flag)),
  setSelectableDates:       dates => dispatch(setSelectableDates(dates)),
  fetchUserTweets:          (year, month, day, page) => dispatch(fetchUserTweets(year, month, day, page)),
  fetchUserSelectableDates: () => dispatch(fetchUserSelectableDates()),
  setApiErrorCode:          code => dispatch(setApiErrorCode(code))
});

export default connect(null, mapDispatchToProps)(UserTimeline);

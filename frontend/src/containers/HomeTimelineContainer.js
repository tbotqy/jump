import { connect } from "react-redux";
import {
  setTweets,
  setIsFetching,
} from "../actions/tweetsActions";
import { setSelectableDates } from "../actions/selectableDatesActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import HomeTimeline from "../components/HomeTimeline";

const mapDispatchToProps = dispatch => ({
  setTweets:          tweets => dispatch(setTweets(tweets)),
  setIsFetching:      flag => dispatch(setIsFetching(flag)),
  setSelectableDates: dates => dispatch(setSelectableDates(dates)),
  setApiErrorCode:    code => dispatch(setApiErrorCode(code))
});

export default connect(null, mapDispatchToProps)(HomeTimeline);

import { connect } from "react-redux";
import {
  setTweets,
  setIsFetching,
} from "../actions/tweetsActions";
import {
  setSelectedYear,
  setSelectedMonth,
  setSelectedDay
} from "../actions/selectedDateActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import DateSelectors from "../components/timeline/DateSelectors";

const mapDispatchToProps = dispatch => ({
  setTweets:        tweets => dispatch(setTweets(tweets)),
  setIsFetching:    flag   => dispatch(setIsFetching(flag)),
  setApiErrorCode:  code   => dispatch(setApiErrorCode(code)),
  setSelectedYear:  year   => dispatch(setSelectedYear(year)),
  setSelectedMonth: month  => dispatch(setSelectedMonth(month)),
  setSelectedDay:   day    => dispatch(setSelectedDay(day))
});

export default connect(
  null,
  mapDispatchToProps,
)(DateSelectors);

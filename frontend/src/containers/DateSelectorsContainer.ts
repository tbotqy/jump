import { connect } from "react-redux";
import {
  setTweets,
  setIsFetching,
} from "../store/tweet/actions";
import {
  setSelectedYear,
  setSelectedMonth,
  setSelectedDay
} from "../store/selected_date/actions";
import { setApiErrorCode } from "../store/api_error/actions";
import DateSelectors from "../components/timeline/DateSelectors";
import { Tweet } from "../store/tweet/types";

const mapDispatchToProps = (dispatch: any) => ({
  setTweets:        (tweets: Tweet[]) => dispatch(setTweets(tweets)),
  setIsFetching:    (flag: boolean)   => dispatch(setIsFetching(flag)),
  setApiErrorCode:  (code: number)    => dispatch(setApiErrorCode(code)),
  setSelectedYear:  (year: number)    => dispatch(setSelectedYear(year)),
  setSelectedMonth: (month: number)   => dispatch(setSelectedMonth(month)),
  setSelectedDay:   (day: number)     => dispatch(setSelectedDay(day))
});

export default connect(
  null,
  mapDispatchToProps,
)(DateSelectors);

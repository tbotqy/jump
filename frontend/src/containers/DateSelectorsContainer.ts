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
import { Tweet } from "../models/tweet";

const mapDispatchToProps = (dispatch: any) => ({
  setTweets:        (tweets: Tweet[]) => dispatch(setTweets(tweets)),
  setIsFetching:    (flag: boolean)   => dispatch(setIsFetching(flag)),
  setApiErrorCode:  (code: number)    => dispatch(setApiErrorCode(code)),
  setSelectedYear:  (year: string)    => dispatch(setSelectedYear(year)),
  setSelectedMonth: (month: string)   => dispatch(setSelectedMonth(month)),
  setSelectedDay:   (day: string)     => dispatch(setSelectedDay(day))
});

export default connect(
  null,
  mapDispatchToProps,
)(DateSelectors);

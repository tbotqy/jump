import { connect } from "react-redux";
import {
  setTweets,
  setIsFetching,
  fetchPublicTweets
} from "../actions/tweetsActions";
import {
  setSelectableDates,
  fetchPublicSelectableDates,
} from "../actions/selectableDatesActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import PublicTimeline from "../components/PublicTimeline";

const mapDispatchToProps = dispatch => ({
  setTweets:                  tweets => dispatch(setTweets(tweets)),
  setIsFetching:              flag => dispatch(setIsFetching(flag)),
  setSelectableDates:         dates => dispatch(setSelectableDates(dates)),
  fetchPublicTweets:          (year, month, day, page) => dispatch(fetchPublicTweets(year, month, day, page)),
  fetchPublicSelectableDates: () => dispatch(fetchPublicSelectableDates()),
  setApiErrorCode:            code => dispatch(setApiErrorCode(code))
});

export default connect(null, mapDispatchToProps)(PublicTimeline);

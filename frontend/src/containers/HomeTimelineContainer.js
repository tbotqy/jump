import { connect } from "react-redux";
import {
  setTweets,
  setIsFetching,
  fetchFolloweeTweets
} from "../actions/tweetsActions";
import {
  setSelectableDates,
  fetchFolloweeSelectableDates
} from "../actions/selectableDatesActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import HomeTimeline from "../components/HomeTimeline";

const mapDispatchToProps = dispatch => ({
  setTweets:                    tweets => dispatch(setTweets(tweets)),
  setIsFetching:                flag => dispatch(setIsFetching(flag)),
  setSelectableDates:           dates => dispatch(setSelectableDates(dates)),
  fetchFolloweeTweets:          (year, month, day, page) => dispatch(fetchFolloweeTweets(year, month, day, page)),
  fetchFolloweeSelectableDates: () => dispatch(fetchFolloweeSelectableDates()),
  setApiErrorCode:              code => dispatch(setApiErrorCode(code))
});

export default connect(null, mapDispatchToProps)(HomeTimeline);

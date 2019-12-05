import { connect } from "react-redux";
import {
  setTweets,
  setIsFetching
} from "../store/tweet/actions";
import { setApiErrorCode } from "../store/api_error/actions";
import UserPage from "../components/UserPage";
import { AppState } from "../store";
import { Tweet } from "../store/tweet/types";

const mapStateToProps = (state: AppState) => ({
  isFetching:    state.tweets.isFetching,
  selectedYear:  state.selectedDate.selectedYear,
  selectedMonth: state.selectedDate.selectedMonth,
  selectedDay:   state.selectedDate.selectedDay
});

const mapDispatchToProps = (dispatch: any) => ({
  setTweets:       (tweets: Tweet[]) => dispatch(setTweets(tweets)),
  setIsFetching:   (flag: boolean) => dispatch(setIsFetching(flag)),
  setApiErrorCode: (code: number) => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(UserPage);

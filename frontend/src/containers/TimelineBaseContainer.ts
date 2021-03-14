import { connect } from "react-redux";
import {
  setTweets,
} from "../store/tweet/actions";
import { setApiErrorCode } from "../store/api_error/actions";
import TimelineBase from "../components/TimelineBase";
import { AppState } from "../store";
import { Tweet } from "../api";


const mapStateToProps = (state: AppState) => ({
  tweets:        state.tweets.tweets,
  selectedYear:  state.selectedDate.selectedYear,
  selectedMonth: state.selectedDate.selectedMonth,
  selectedDay:   state.selectedDate.selectedDay
});

const mapDispatchToProps = (dispatch: any) => ({
  setTweets:       (tweets: Tweet[]) => dispatch(setTweets(tweets)),
  setApiErrorCode: (code: number) => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(TimelineBase);

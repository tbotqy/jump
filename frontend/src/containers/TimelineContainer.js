import { connect } from "react-redux";
import {
  setTweets,
  setIsFetching
} from "../actions/tweetsActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import Timeline from "../components/Timeline";

const mapStateToProps = state => ({
  tweets:          state.tweets.tweets,
  isFetching:      state.tweets.isFetching,
  apiErrorCode:    state.apiError.code,
  selectableDates: state.selectableDates.selectableDates
});

const mapDispatchToProps = dispatch => ({
  setIsFetching:   flag   => dispatch(setIsFetching(flag)),
  setTweets:       tweets => dispatch(setTweets(tweets)),
  setApiErrorCode: code   => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Timeline);

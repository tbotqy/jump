import { connect } from "react-redux";
import {
  setTweets,
  setIsFetching,
} from "../actions/tweetsActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import DateSelectors from "../components/timeline/DateSelectors";

const mapDispatchToProps = dispatch => ({
  setTweets: tweets => dispatch(setTweets(tweets)),
  setIsFetching: flag => dispatch(setIsFetching(flag)),
  setApiErrorCode: code => dispatch(setApiErrorCode(code))
});

export default connect(
  null,
  mapDispatchToProps,
)(DateSelectors);

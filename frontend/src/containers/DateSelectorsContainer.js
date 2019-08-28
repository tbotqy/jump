import { connect } from "react-redux";
import { setTweets } from "../actions/tweetsActions";
import { resetPage } from "../actions/pageActions";
import DateSelectors from "../components/timeline/DateSelectors";

const mapDispatchToProps = dispatch => ({
  setTweets: tweets => dispatch(setTweets(tweets)),
  resetPage: () => dispatch(resetPage())
});

export default connect(
  null,
  mapDispatchToProps,
)(DateSelectors);

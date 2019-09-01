import { connect } from "react-redux";
import {
  setTweets,
  resetHasMore
} from "../actions/tweetsActions";
import { resetPage } from "../actions/pageActions";
import DateSelectors from "../components/timeline/DateSelectors";

const mapDispatchToProps = dispatch => ({
  setTweets: tweets => dispatch(setTweets(tweets)),
  resetPage: () => dispatch(resetPage()),
  resetHasMore: () => dispatch(resetHasMore())
});

export default connect(
  null,
  mapDispatchToProps,
)(DateSelectors);

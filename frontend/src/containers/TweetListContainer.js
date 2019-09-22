import { connect } from "react-redux";
import {
  appendTweets,
  setHasMore,
  resetHasMore,
} from "../actions/tweetsActions";
import {
  setPage,
  resetPage
} from "../actions/pageActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import TweetList from "../components/TweetList";

const mapStateToProps = state => ({
  tweets:  state.tweets.tweets,
  hasMore: state.tweets.hasMore,
  page:    state.page.page
});

const mapDispatchToProps = dispatch => ({
  appendTweets:    tweets => dispatch(appendTweets(tweets)),
  setHasMore:      flag => dispatch(setHasMore(flag)),
  resetHasMore:    () => dispatch(resetHasMore()),
  setPage:         page => dispatch(setPage(page)),
  resetPage:       () => dispatch(resetPage()),
  setApiErrorCode: code => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(TweetList);

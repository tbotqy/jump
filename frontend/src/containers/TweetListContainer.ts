import { connect } from "react-redux";
import {
  appendTweets,
  setHasMore,
  resetHasMore,
} from "../store/tweet/actions";
import {
  setPage,
  resetPage
} from "../store/page/actions";
import { setApiErrorCode } from "../store/api_error/actions";
import TweetList from "../components/TweetList";
import { AppState } from "../store";
import { Tweet } from "../models/tweet";

const mapStateToProps = (state: AppState) => ({
  tweets:  state.tweets.tweets,
  hasMore: state.tweets.hasMore,
  page:    state.page.page
});

const mapDispatchToProps = (dispatch: any) => ({
  appendTweets:    (tweets: Tweet[]) => dispatch(appendTweets(tweets)),
  setHasMore:      (flag: boolean) => dispatch(setHasMore(flag)),
  resetHasMore:    () => dispatch(resetHasMore()),
  setPage:         (page: number) => dispatch(setPage(page)),
  resetPage:       () => dispatch(resetPage()),
  setApiErrorCode: (code: number) => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(TweetList);

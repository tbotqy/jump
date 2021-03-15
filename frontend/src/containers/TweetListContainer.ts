import { connect } from "react-redux";
import { appendTweets } from "../store/tweet/actions";
import { setApiErrorCode } from "../store/api_error/actions";
import TweetList from "../components/TweetList";
import { AppState } from "../store";
import { Tweet } from "../api";

const mapStateToProps = (state: AppState) => ({ tweets:  state.tweets.tweets });

const mapDispatchToProps = (dispatch: any) => ({
  appendTweets:    (tweets: Tweet[]) => dispatch(appendTweets(tweets)),
  setApiErrorCode: (code: number) => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(TweetList);

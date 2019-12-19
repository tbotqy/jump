import { connect } from "react-redux";
import HeadProgressBar from "../components/HeadProgressBar";
import { AppState } from "../store";

const mapStateToProps = (state: AppState) => ({
  isFetching: state.tweets.isFetching
});

export default connect(mapStateToProps, null)(HeadProgressBar);

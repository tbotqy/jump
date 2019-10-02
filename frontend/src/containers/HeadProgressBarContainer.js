import { connect } from "react-redux";
import HeadProgressBar from "../components/HeadProgressBar";

const mapStateToProps = state => ({
  isFetching: state.tweets.isFetching
});

export default connect(mapStateToProps, null)(HeadProgressBar);

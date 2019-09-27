import { connect } from "react-redux";
import { resetApiErrorCode } from "../actions/apiErrorActions";
import ApiErrorBoundary from "../components/ApiErrorBoundary";

const mapStateToProps = state => ({
  apiErrorCode: state.apiError.code
});

const mapDispatchToProps = dispatch => ({
  resetApiErrorCode: () => dispatch(resetApiErrorCode())
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ApiErrorBoundary);

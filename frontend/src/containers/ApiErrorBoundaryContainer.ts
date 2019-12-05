import { connect } from "react-redux";
import { resetApiErrorCode } from "../store/api_error/actions";
import ApiErrorBoundary from "../components/ApiErrorBoundary";
import { AppState } from "../store";

const mapStateToProps = (state: AppState) => ({
  apiErrorCode: state.apiError.code
});

const mapDispatchToProps = (dispatch: any) => ({
  resetApiErrorCode: () => dispatch(resetApiErrorCode())
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ApiErrorBoundary);

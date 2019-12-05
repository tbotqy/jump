import { connect } from "react-redux";
import { setApiErrorCode } from "../store/api_error/actions";
import Import from "../components/Import";
import { AppState } from "../store";

const mapStateToProps = (state: AppState) => ({
  user: state.user.user
});

const mapDispatchToProps = (dispatch: any) => ({
  setApiErrorCode: (code: number) => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Import);

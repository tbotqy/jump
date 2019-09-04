import { connect } from "react-redux";
import { setApiErrorCode } from "../actions/apiErrorActions";
import Import from "../components/Import";

const mapStateToProps = state => ({
  user: state.user.user
});

const mapDispatchToProps = dispatch => ({
  setApiErrorCode: code => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Import);

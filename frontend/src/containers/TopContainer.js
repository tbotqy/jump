import { connect } from "react-redux";
import { setApiErrorCode } from "../actions/apiErrorActions";
import Top from "../components/Top";

const mapDispatchToProps = dispatch => ({
  setApiErrorCode: code => dispatch(setApiErrorCode(code))
});

export default connect(
  null,
  mapDispatchToProps
)(Top);

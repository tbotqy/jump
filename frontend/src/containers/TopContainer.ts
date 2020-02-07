import { connect } from "react-redux";
import { setApiErrorCode } from "../store/api_error/actions";
import Top from "../pages/Top";

const mapDispatchToProps = (dispatch: any) => ({
  setApiErrorCode: (code: number) => dispatch(setApiErrorCode(code))
});

export default connect(
  null,
  mapDispatchToProps
)(Top);

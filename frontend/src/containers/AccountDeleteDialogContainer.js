import { connect } from "react-redux";
import { setApiErrorCode } from "../actions/apiErrorActions";
import AccountDeleteDialog from "../components/data_management/AccountDeleteDialog";

const mapDispatchToProps = dispatch => ({
  setApiErrorCode: code => dispatch(setApiErrorCode(code))
});

export default connect(
  null,
  mapDispatchToProps
)(AccountDeleteDialog);

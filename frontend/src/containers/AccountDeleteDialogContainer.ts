import { connect } from "react-redux";
import { setApiErrorCode } from "../store/api_error/actions";
import AccountDeleteDialog from "../components/data_management/AccountDeleteDialog";

const mapDispatchToProps = (dispatch: any) => ({
  setApiErrorCode: (code: number) => dispatch(setApiErrorCode(code))
});

export default connect(
  null,
  mapDispatchToProps
)(AccountDeleteDialog);

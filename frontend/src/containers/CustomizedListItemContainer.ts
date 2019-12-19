import { connect } from "react-redux";
import { setApiErrorCode } from "../store/api_error/actions";
import CustomizedListItem from "../components/data_management/CustomizedListItem";

const mapDispatchToProps = (dispatch: any) => ({
  setApiErrorCode: (code: number) => dispatch(setApiErrorCode(code))
});

export default connect(
  null,
  mapDispatchToProps
)(CustomizedListItem);

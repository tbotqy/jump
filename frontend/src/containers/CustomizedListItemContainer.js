import { connect } from "react-redux";
import { setApiErrorCode } from "../actions/apiErrorActions";
import CustomizedListItem from "../components/data_management/CustomizedListItem";

const mapDispatchToProps = dispatch => ({
  setApiErrorCode: code => dispatch(setApiErrorCode(code))
});

export default connect(
  null,
  mapDispatchToProps
)(CustomizedListItem);

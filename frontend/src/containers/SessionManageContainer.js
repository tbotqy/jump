import { connect } from "react-redux";
import { setIsAuthenticated } from "../actions/userActions";
import SessionManage from "../components/SessionManage";

const mapDispatchToProps = dispatch => ({
  setIsAuthenticated: flag => dispatch(setIsAuthenticated(flag))
});

export default connect(
  null,
  mapDispatchToProps
)(SessionManage);

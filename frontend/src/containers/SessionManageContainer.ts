import { connect } from "react-redux";
import { setIsAuthenticated } from "../store/user/actions";
import SessionManage from "../components/SessionManage";

const mapDispatchToProps = (dispatch: any) => ({
  setIsAuthenticated: (flag: boolean) => dispatch(setIsAuthenticated(flag))
});

export default connect(
  null,
  mapDispatchToProps
)(SessionManage);

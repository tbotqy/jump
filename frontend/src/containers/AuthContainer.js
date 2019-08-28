import { connect } from "react-redux";
import { setIsAuthenticated } from "../actions/userActions";
import Auth from "../components/Auth";

const mapDispatchToProps = dispatch => ({
  setIsAuthenticated: flag => dispatch(setIsAuthenticated(flag))
});

export default connect(
  null,
  mapDispatchToProps
)(Auth);

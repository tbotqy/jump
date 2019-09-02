import { connect } from "react-redux";
import Auth from "../components/Auth";

const mapStateToProps = state => ({
  isAuthenticated: state.user.isAuthenticated
});

export default connect(
  mapStateToProps,
  null
)(Auth);

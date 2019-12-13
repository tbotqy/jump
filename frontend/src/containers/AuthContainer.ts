import { connect } from "react-redux";
import Auth from "../components/Auth";
import { AppState } from "../store";

const mapStateToProps = (state: AppState) => ({
  isAuthenticated: state.user.isAuthenticated
});

export default connect(
  mapStateToProps,
  null
)(Auth as any);

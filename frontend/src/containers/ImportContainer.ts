import { connect } from "react-redux";
import Import from "../pages/Import";
import { AppState } from "../store";

const mapStateToProps = (state: AppState) => ({
  user: state.user.user
});

export default connect(
  mapStateToProps,
  null
)(Import);

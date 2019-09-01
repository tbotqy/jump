import { connect } from "react-redux";
import Import from "../components/Import";

const mapStateToProps = state => ({
  user: state.user.user
});

export default connect(
  mapStateToProps,
  null
)(Import);

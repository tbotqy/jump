import { connect } from "react-redux";
import DataManagement from "../components/DataManagement";

const mapStateToProps = state => ({
  user: state.user.user
});

export default connect(
  mapStateToProps,
  null
)(DataManagement);

import { connect } from "react-redux";
import HeadNav from "../components/HeadNav";
import { AppState } from "../store";

const mapStateToProps = (state: AppState) => ({
  isAuthenticated: state.user.isAuthenticated
});

export default connect(mapStateToProps, null)(HeadNav);

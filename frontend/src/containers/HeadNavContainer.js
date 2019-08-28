import { connect } from "react-redux";
import HeadNav from "../components/HeadNav";


const mapStateToProps = state => ({
  isAuthenticated: state.user.isAuthenticated
});

export default connect(mapStateToProps, null)(HeadNav);

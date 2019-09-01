import { connect } from "react-redux";
import {
  fetchUser,
  setUser
} from "../actions/userActions";
import Import from "../components/Import";

const mapStateToProps = state => ({
  user: state.user.user
});

const mapDispatchToProps = dispatch => ({
  fetchUser: () => dispatch(fetchUser()),
  setUser:   user => dispatch(setUser(user))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Import);

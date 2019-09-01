import { connect } from "react-redux";
import {
  fetchUser,
  setUser
} from "../actions/userActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import UserMenu from "../components/head_nav/UserMenu";

const mapStateToProps = state => ({
  user: state.user.user
});

const mapDispatchToProps = dispatch => ({
  fetchUser:       () => dispatch(fetchUser()),
  setUser:         user => dispatch(setUser(user)),
  setApiErrorCode: code => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(UserMenu);
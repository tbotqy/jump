import { connect } from "react-redux";
import { setUser } from "../store/user/actions";
import UserMenu from "../components/head_nav/UserMenu";
import { AppState } from "../store";
import { User } from "../api";

const mapStateToProps = (state: AppState) => ({
  user: state.user.user
});

const mapDispatchToProps = (dispatch: any) => ({
  setUser: (user: User) => dispatch(setUser(user))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(UserMenu);

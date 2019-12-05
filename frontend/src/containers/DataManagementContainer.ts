import { connect } from "react-redux";
import { setUser } from "../store/user/actions";
import { setApiErrorCode } from "../store/api_error/actions";
import DataManagement from "../components/DataManagement";
import { AppState } from "../store";
import { User } from "../store/user/types";

const mapStateToProps = (state: AppState) => ({
  user: state.user.user
});

const mapDispatchToProps = (dispatch: any) => ({
  setUser:         (user: User) => dispatch(setUser(user)),
  setApiErrorCode: (code: number) => dispatch(setApiErrorCode(code))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(DataManagement);

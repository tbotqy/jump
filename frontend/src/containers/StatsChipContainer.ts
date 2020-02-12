import { connect } from "react-redux";
import { setApiErrorCode } from "../store/api_error/actions";
import StatsChip from "../components/StatsChip";

const mapDispatchToProps = (dispatch: any) => ({
  setApiErrorCode: (code: number) => dispatch(setApiErrorCode(code))
});

export default connect(
  null,
  mapDispatchToProps
)(StatsChip);

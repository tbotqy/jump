import { connect } from "react-redux";
import {
  setSelectedYear,
  setSelectedMonth,
  setSelectedDay
} from "../store/selected_date/actions";
import DateSelectors from "../components/timeline/DateSelectors";

const mapDispatchToProps = (dispatch: any) => ({
  setSelectedYear: (year: string) => dispatch(setSelectedYear(year)),
  setSelectedMonth: (month: string) => dispatch(setSelectedMonth(month)),
  setSelectedDay: (day: string) => dispatch(setSelectedDay(day))
});

export default connect(
  null,
  mapDispatchToProps,
)(DateSelectors);

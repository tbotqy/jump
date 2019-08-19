import { connect } from "react-redux";
import {
  setSelectedYear,
  setSelectedMonth,
  setSelectedDay
} from "../actions/selectableDatesActions";
import DateSelectors from "../components/timeline/DateSelectors";

const mapStateToProps = state => ({
  selectedYear:    state.selectableDates.selectedYear,
  selectedMonth:   state.selectableDates.selectedMonth,
  selectedDay:     state.selectableDates.selectedDay
});

const mapDispatchToProps = dispatch => ({
  setSelectedYear:  year  => dispatch(setSelectedYear(year)),
  setSelectedMonth: month => dispatch(setSelectedMonth(month)),
  setSelectedDay:   day   => dispatch(setSelectedDay(day))
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(DateSelectors);

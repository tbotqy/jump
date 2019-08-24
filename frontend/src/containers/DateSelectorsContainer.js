import { connect } from "react-redux";
import {
  setSelectableDates,
  setSelectedYear,
  setSelectedMonth,
  setSelectedDay,
  finishedToFetchSelectableDates
} from "../actions/selectableDatesActions";
import { setApiErrorCode } from "../actions/apiErrorActions";
import DateSelectors from "../components/timeline/DateSelectors";

const mapStateToProps = state => ({
  selectableDates:  state.selectableDates.selectableDates,
  selectedYear:     state.selectableDates.selectedYear,
  selectedMonth:    state.selectableDates.selectedMonth,
  selectedDay:      state.selectableDates.selectedDay,
  loaded:           state.selectableDates.loaded,
  timelineBasePath: state.timeline.timelineBasePath
});

const mapDispatchToProps = dispatch => ({
  setSelectableDates:  selectableDates  => dispatch(setSelectableDates(selectableDates)),
  setSelectedYear:     year  => dispatch(setSelectedYear(year)),
  setSelectedMonth:    month => dispatch(setSelectedMonth(month)),
  setSelectedDay:      day   => dispatch(setSelectedDay(day)),
  setApiErrorCode:     code  => dispatch(setApiErrorCode(code)),
  finishedToFetchSelectableDates: () => dispatch(finishedToFetchSelectableDates())
});

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(DateSelectors);

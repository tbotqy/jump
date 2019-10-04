import React          from "react";
import { withRouter } from "react-router-dom";
import scrollToTop    from "../../utils/scrollToTop";
import { Grid }       from "@material-ui/core";
import Selector       from "./date_selectors/Selector";

import DateCollection from "../../utils/DateCollection";

class DateSelectors extends React.Component {
  constructor(props) {
    super(props);

    const dateParser = new DateCollection(props.selectableDates);
    this.dateParser  = dateParser;

    const { year, month, day } = props.match.params;
    const selectedYear  = year  || dateParser.latestYear();
    const selectedMonth = month || dateParser.latestMonthByYear(selectedYear);
    const selectedDay   = day   || dateParser.latestDayByYearAndMonth(selectedYear, selectedMonth);

    this.state = { selectedYear, selectedMonth, selectedDay };
    this.selectedYear  = selectedYear;
    this.selectedMonth = selectedMonth;
    this.selectedDay   = selectedDay;

    this.onPopStateFunc = this.onBackOrForwardButtonEvent.bind(this);
    window.addEventListener("popstate", this.onPopStateFunc);
  }

  componentDidMount() {
    this.propagateSelectedValues(this.selectedYear, this.selectedMonth, this.selectedDay);
  }

  handleYearChange(year) {
    const month = this.dateParser.latestMonthByYear(year);
    const day   = this.dateParser.latestDayByYearAndMonth(year, month);
    this.setState({
      selectedYear:  year,
      selectedMonth: month,
      selectedDay:   day
    });

    this.fetchTweets(year, month, day);
    this.updateDatePath(year);
    this.propagateSelectedValues(year, month, day);
    scrollToTop();
  }

  handleMonthChange(month) {
    const year = this.state.selectedYear;
    const day  = this.dateParser.latestDayByYearAndMonth(year, month);
    this.setState({
      selectedMonth: month,
      selectedDay:   day
    });

    this.fetchTweets(year, month, day);
    this.updateDatePath(`${year}/${month}`);
    this.propagateSelectedValues(year, month, day);
    scrollToTop();
  }

  handleDayChange(day) {
    this.setState({ selectedDay: day });

    const { selectedYear, selectedMonth } = this.state;
    this.fetchTweets(selectedYear, selectedMonth, day);
    this.updateDatePath(`${selectedYear}/${selectedMonth}/${day}`);
    this.propagateSelectedValues(selectedYear, selectedMonth, day);
    scrollToTop();
  }

  updateDatePath(datePath) {
    const { screenName } = this.props.match.params;
    const timelineType   = this.props.match.path.split("/")[1]; // e.g public_timeline
    let newPath = "";
    if(screenName) {
      newPath = `/${timelineType}/${screenName}/${datePath}`;
    }else{
      newPath = `/${timelineType}/${datePath}`;
    }
    this.props.history.push(newPath);
  }

  onBackOrForwardButtonEvent(e) {
    e.preventDefault();

    const { year, month, day } = this.props.match.params;
    const selectedYear  = year  || this.dateParser.latestYear();
    const selectedMonth = month || this.dateParser.latestMonthByYear(selectedYear);
    const selectedDay   = day   || this.dateParser.latestDayByYearAndMonth(selectedYear, selectedMonth);
    this.setState({ selectedYear, selectedMonth, selectedDay });
    this.propagateSelectedValues(selectedYear, selectedMonth, selectedDay);
  }

  render() {
    return(
      <Grid container justify="flex-end" spacing={ 1 }>
        <Grid item>
          <Selector
            selections={ this.dateParser.years() }
            selectedValue={ this.state.selectedYear }
            selectedValueUpdater={ this.handleYearChange.bind(this) }
          />
        </Grid>
        <Grid item>
          <Selector
            selections={ this.dateParser.monthsByYear(this.state.selectedYear) }
            selectedValue={ this.state.selectedMonth }
            selectedValueUpdater={ this.handleMonthChange.bind(this) }
          />
        </Grid>
        <Grid item>
          <Selector
            selections={ this.dateParser.daysByYearAndMonth(this.state.selectedYear, this.state.selectedMonth) }
            selectedValue={ this.state.selectedDay }
            selectedValueUpdater={ this.handleDayChange.bind(this) }
          />
        </Grid>
      </Grid>
    );
  }

  componentWillUnmount() {
    window.removeEventListener("popstate", this.onPopStateFunc);
  }

  async fetchTweets(year, month, day) {
    this.props.setIsFetching(true);
    try {
      const response = await this.props.onSelectionChangeTweetsFetchFunc(year, month, day);
      this.props.setTweets(response.data);
    } catch(error) {
      this.props.setApiErrorCode(error.response.status);
    } finally {
      this.props.setIsFetching(false);
    }
  }

  propagateSelectedValues(year, month, day) {
    this.props.setSelectedYear(year);
    this.props.setSelectedMonth(month);
    this.props.setSelectedDay(day);
  }
}

export default withRouter(DateSelectors);

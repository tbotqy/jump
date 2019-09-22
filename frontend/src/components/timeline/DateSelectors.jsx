import React          from "react";
import { withRouter } from "react-router-dom";
import scrollToTop    from "../../utils/scrollToTop";
import { Grid }       from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import Selector       from "./date_selectors/Selector";

import DateCollection from "../../utils/DateCollection";

const styles = theme => ({
  container: {
    position: "sticky",
    bottom: theme.spacing(3)
  }
});

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

    this.onPopStateFunc = this.onBackOrForwardButtonEvent.bind(this);
    window.addEventListener("popstate", this.onPopStateFunc);
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
    scrollToTop();
  }

  handleDayChange(day) {
    this.setState({ selectedDay: day });

    const { selectedYear, selectedMonth } = this.state;
    this.fetchTweets(selectedYear, selectedMonth, day);
    this.updateDatePath(`${selectedYear}/${selectedMonth}/${day}`);
    scrollToTop();
  }

  updateDatePath(datePath) {
    const timelineType = this.props.match.path.split("/")[1]; // e.g public_timeline
    const newPath = `/${timelineType}/${datePath}`;
    this.props.history.push(newPath);
  }

  onBackOrForwardButtonEvent(e) {
    e.preventDefault();

    const { year, month, day } = this.props.match.params;
    const selectedYear  = year  || this.dateParser.latestYear();
    const selectedMonth = month || this.dateParser.latestMonthByYear(selectedYear);
    const selectedDay   = day   || this.dateParser.latestDayByYearAndMonth(selectedYear, selectedMonth);
    this.setState({ selectedYear, selectedMonth, selectedDay });
  }

  render() {
    return(
      <Grid container justify="flex-end" spacing={ 1 } className={ this.props.classes.container }>
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

  fetchTweets(year, month, day) {
    this.props.setIsFetching(true);
    this.props.onSelectionChangeTweetsFetchFunc(year, month, day)
      .then( response => this.props.setTweets(response.data))
      .then( () => this.props.setIsFetching(false) );
  }
}

export default withRouter(withStyles(styles)(DateSelectors));

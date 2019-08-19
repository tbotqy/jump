import React          from "react";
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
    this.dateParser = new DateCollection(props.selectableDates); // TODO: Rename class
  }

  handleYearChange(year) {
    this.props.setSelectedYear(year);
    // reset other selectors
    const month = this.dateParser.latestMonthByYear(year);
    const day   = this.dateParser.latestDayByYearAndMonth(year, month);
    this.props.setSelectedMonth(month);
    this.props.setSelectedDay(day);
    // fetch tweets with currently selected values
    this.props.tweetsFetcher(year, month, day);
    scrollToTop();
  }

  handleMonthChange(month) {
    const year = this.props.selectedYear;
    this.props.setSelectedMonth(month);
    // reset day selector
    const day = this.dateParser.latestDayByYearAndMonth(year, month);
    this.props.setSelectedDay(day);
    // fetch tweets with currently selected values
    this.props.tweetsFetcher(year, month, day);
    scrollToTop();
  }

  handleDayChange(day) {
    this.props.setSelectedDay(day);
    // fetch tweets with currently selected values
    this.props.tweetsFetcher(this.props.selectedYear, this.props.selectedMonth, day);
    scrollToTop();
  }

  render() {
    const props = this.props;
    return(
      <Grid container justify="flex-end" spacing={ 1 } className={ props.classes.container }>
        <Grid item>
          <Selector
            selections={ this.dateParser.years() }
            selectedValue={ props.selectedYear }
            selectedValueUpdater={ this.handleYearChange.bind(this) }
          />
        </Grid>
        <Grid item>
          <Selector
            selections={ this.dateParser.monthsByYear(props.selectedYear) }
            selectedValue={ props.selectedMonth }
            selectedValueUpdater={ this.handleMonthChange.bind(this) }
          />
        </Grid>
        <Grid item>
          <Selector
            selections={ this.dateParser.daysByYearAndMonth(props.selectedYear, props.selectedMonth) }
            selectedValue={ props.selectedDay }
            selectedValueUpdater={ this.handleDayChange.bind(this) }
          />
        </Grid>
      </Grid>
    );
  }
}

export default withStyles(styles)(DateSelectors);

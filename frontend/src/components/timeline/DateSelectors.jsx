import React          from "react";
import { Grid }       from "@material-ui/core";
import Selector       from "./date_selectors/Selector";
import { withStyles } from "@material-ui/core/styles";

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
    this.dateCollection = new DateCollection(props.dates);

    this.state = {
      years:         this.dateCollection.years(),
      months:        this.dateCollection.latestMonths(),
      days:          this.dateCollection.latestDays(),
      selectedYear:  this.dateCollection.latestYear(),
      selectedMonth: this.dateCollection.latestMonth(),
      selectedDay:   this.dateCollection.latestDay()
    };

    this.classes = props.classes;
    this.selectedDateUpdater = props.selectedDateUpdater;
  }

  onYearChange(selectedYear) {
    const months            = this.dateCollection.monthsByYear(selectedYear);
    const latestMonthOfYear = months[0];
    const days              = this.dateCollection.daysByYearAndMonth(selectedYear, latestMonthOfYear);

    this.setState({
      selectedYear:  selectedYear,
      selectedMonth: latestMonthOfYear,
      selectedDay:   days[0],
      months:        months,
      days:          days
    });

    this.selectedDateUpdater(selectedYear, null, null);
  }

  onMonthChange(selectedMonth) {
    const daysOfMonth = this.dateCollection.daysByYearAndMonth(this.state.selectedYear, selectedMonth);

    this.setState({
      selectedMonth: selectedMonth,
      selectedDay:   daysOfMonth[0],
      days:          daysOfMonth
    });

    this.selectedDateUpdater(this.state.selectedYear, selectedMonth, null);
  }

  onDayChange(selectedDay) {
    this.setState({
      selectedDay: selectedDay
    });

    this.selectedDateUpdater(this.state.selectedYear, this.state.selectedMonth, selectedDay);
  }

  render() {
    return(
      <Grid container justify="flex-end" spacing={ 1 } className={ this.classes.container }>
        <Grid item>
          <Selector selections={ this.state.years } selectedValue={ this.state.selectedYear } otherSelectorUpdater={ this.onYearChange.bind(this) } />
        </Grid>
        <Grid item>
          <Selector selections={ this.state.months } selectedValue={ this.state.selectedMonth } otherSelectorUpdater={ this.onMonthChange.bind(this) } />
        </Grid>
        <Grid item>
          <Selector selections={ this.state.days } selectedValue={ this.state.selectedDay } otherSelectorUpdater={ this.onDayChange.bind(this) } />
        </Grid>
      </Grid>
    );
  }
}

export default withStyles(styles)(DateSelectors);

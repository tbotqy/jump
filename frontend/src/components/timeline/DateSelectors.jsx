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

    if(this.props.selectableDates.length > 0) {
      this.dateParser = new DateCollection(this.props.selectableDates);
    }
  }

  componentDidMount() {
    if(this.props.selectableDates.length <= 0) {
      this.props.selectableDatesFetcher()
        .then( selectableDates => {
          this.props.setSelectableDates(selectableDates);
          const { params }    = this.props.match;
          const dateParser    = new DateCollection(selectableDates);

          const selectedYear  = params.year  || dateParser.latestYear();
          const selectedMonth = params.month || dateParser.latestMonthByYear(selectedYear);
          const selectedDay   = params.day   || dateParser.latestDayByYearAndMonth(selectedYear, selectedMonth);

          this.props.setSelectedYear(selectedYear);
          this.props.setSelectedMonth(selectedMonth);
          this.props.setSelectedDay(selectedDay);
          this.dateParser = dateParser;

          this.props.finishedToFetchSelectableDates();
        }).catch( error => {
          this.props.setApiErrorCode(error.response.status);
        });
    }
    window.onpopstate = this.onBackOrForwardButtonEvent.bind(this);
  }

  componentWillUnmount() {
    window.onpopstate = () => {};
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
    this.updateDatePath(year);
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
    this.updateDatePath(`${year}/${month}`);
    scrollToTop();
  }

  handleDayChange(day) {
    this.props.setSelectedDay(day);
    // fetch tweets with currently selected values
    const { selectedYear, selectedMonth } = this.props;
    this.props.tweetsFetcher(selectedYear, selectedMonth, day);
    this.updateDatePath(`${selectedYear}/${selectedMonth}/${day}`);
    scrollToTop();
  }

  updateDatePath(datePath) {
    const path = `${this.props.timelineBasePath}${datePath}`;
    this.props.history.push(path);
  }

  onBackOrForwardButtonEvent(e) {
    e.preventDefault();
    if(this.props.tweetsAreBeingFetched) {
      return;
    }

    const { year, month, day } = this.props.match.params;
    this.props.tweetsFetcher(year, month, day);

    const selectedYear  = year  || this.dateParser.latestYear();
    const selectedMonth = month || this.dateParser.latestMonthByYear(selectedYear);
    const selectedDay   = day   || this.dateParser.latestDayByYearAndMonth(selectedYear, selectedMonth);
    this.props.setSelectedYear(selectedYear);
    this.props.setSelectedMonth(selectedMonth);
    this.props.setSelectedDay(selectedDay);
  }

  render() {
    if (!this.props.loaded) {
      return <></>;
    }else{
      return(
        <Grid container justify="flex-end" spacing={ 1 } className={ this.props.classes.container }>
          <Grid item>
            <Selector
              selections={ this.dateParser.years() }
              selectedValue={ this.props.selectedYear }
              selectedValueUpdater={ this.handleYearChange.bind(this) }
            />
          </Grid>
          <Grid item>
            <Selector
              selections={ this.dateParser.monthsByYear(this.props.selectedYear) }
              selectedValue={ this.props.selectedMonth }
              selectedValueUpdater={ this.handleMonthChange.bind(this) }
            />
          </Grid>
          <Grid item>
            <Selector
              selections={ this.dateParser.daysByYearAndMonth(this.props.selectedYear, this.props.selectedMonth) }
              selectedValue={ this.props.selectedDay }
              selectedValueUpdater={ this.handleDayChange.bind(this) }
            />
          </Grid>
        </Grid>
      );
    }
  }
}

export default withRouter(withStyles(styles)(DateSelectors));

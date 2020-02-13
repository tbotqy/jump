import React from "react";
import {
  withRouter,
  RouteComponentProps
} from "react-router-dom";
import { Grid } from "@material-ui/core";
import Selector from "./date_selectors/Selector";

import DateParser from "../../utils/DateParser";
import { AxiosPromise } from "axios";
import {
  TimelineParams
} from "../types";
import {
  DateParams,
  TweetDate,
  Tweet
} from "../../api";

interface Props extends RouteComponentProps<TimelineParams> {
  selectableDates: TweetDate[];
  onSelectionChangeTweetsFetchFunc: ({ year, month, day }: DateParams) => AxiosPromise;
  basePath: string;
  setIsFetching: (flag: boolean) => void;
  setTweets: (tweets: Tweet[]) => void;
  setApiErrorCode: (code: number) => void;
  setSelectedYear: (year: string) => void;
  setSelectedMonth: (month: string) => void;
  setSelectedDay: (day: string) => void;
}

interface State {
  selectedYear: string;
  selectedMonth: string;
  selectedDay: string;
}

class DateSelectors extends React.Component<Props, State> {
  private dateParser: DateParser
  private onPopStateFunc: (e: Event) => void

  constructor(props: Props) {
    super(props);

    const dateParser = new DateParser(props.selectableDates);
    this.dateParser = dateParser;

    const { year, month, day } = props.match.params;
    const selectedYear = year || dateParser.latestYear();
    const selectedMonth = month || dateParser.latestMonthByYear(selectedYear);
    const selectedDay = day || dateParser.latestDayByYearAndMonth(selectedYear, selectedMonth);

    this.state = { selectedYear, selectedMonth, selectedDay };

    this.onPopStateFunc = this.onBackOrForwardButtonEvent.bind(this);
    window.addEventListener("popstate", this.onPopStateFunc);

    this.propagateSelectedDate(selectedYear, selectedMonth, selectedDay);
  }

  componentDidUpdate(prevProps: Props) {
    if (this.props.match.url !== prevProps.match.url) {
      this.resetSelectedDate();
    }
  }

  onBackOrForwardButtonEvent(e: Event) {
    e.preventDefault();
    this.resetSelectedDate();
  }

  resetSelectedDate() {
    const { year, month, day } = this.props.match.params;
    const selectedYear = year || this.dateParser.latestYear();
    const selectedMonth = month || this.dateParser.latestMonthByYear(selectedYear);
    const selectedDay = day || this.dateParser.latestDayByYearAndMonth(selectedYear, selectedMonth);
    this.setState({ selectedYear, selectedMonth, selectedDay });
    this.propagateSelectedDate(selectedYear, selectedMonth, selectedDay);
  }

  render() {
    const { basePath } = this.props;
    return (
      <Grid container justify="flex-end" spacing={1}>
        <Grid item>
          <Selector
            paths={this.dateParser.years().map(y => `${basePath}/${y}`)}
            selectedValue={this.state.selectedYear}
          />
        </Grid>
        <Grid item>
          <Selector
            paths={this.dateParser.monthsByYear(this.state.selectedYear).map(m => `${basePath}/${this.state.selectedYear}/${m}`)}
            selectedValue={this.state.selectedMonth}
          />
        </Grid>
        <Grid item>
          <Selector
            paths={
              this.dateParser.daysByYearAndMonth(this.state.selectedYear, this.state.selectedMonth)
                .map(d => `${basePath}/${this.state.selectedYear}/${this.state.selectedMonth}/${d}`)
            }
            selectedValue={this.state.selectedDay}
          />
        </Grid>
      </Grid>
    );
  }

  componentWillUnmount() {
    window.removeEventListener("popstate", this.onPopStateFunc);
  }

  propagateSelectedDate(year: string, month: string, day: string) {
    this.props.setSelectedYear(year);
    this.props.setSelectedMonth(month);
    this.props.setSelectedDay(day);
  }
}

export default withRouter(DateSelectors);

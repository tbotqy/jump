import React from "react";
import { withRouter } from "react-router-dom";
import {
  Container,
  LinearProgress
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import axios from "axios";

import HeadNav       from "./HeadNav";
import DateSelectors from "./timeline/DateSelectors";
import TweetList     from "./TweetList";

const apiOrigin = process.env.REACT_APP_API_ORIGIN;

const styles = theme => ({
  container: {
    paddingTop:   theme.spacing(3),
    paddingLeft:  theme.spacing(1),
    paddingRight: theme.spacing(1)
  },
  tweetListContainer: {
    minHeight: "100vh"
  }
});

class PublicTimeline extends React.Component {
  constructor(props) {
    super(props);

    const { params } = props.match;

    this.state = {
      dates:  [],
      tweets: [],
      selectedYear:  params.year,
      selectedMonth: params.month,
      selectedDay:   params.day
    };

    this.props = props;
  }

  componentDidMount() {
    fetch(`${apiOrigin}/tweeted_dates`)
      .then( response => response.json() )
      .then( json => {
        this.setState({ dates: json });
      });

    const params = { year: this.state.selectedYear, month: this.state.selectedMonth, day: this.state.selectedDay };
    axios.get(`${apiOrigin}/statuses`, { params: params })
      .then( response => response.data )
      .then( tweets => {
        this.setState({ tweets: tweets });
      });

    window.onpopstate = (e) => {
      const [year, month, day] = window.location.pathname.split("/").slice(2).filter(function(e){return e});
      this.setState({
        selectedYear:  year,
        selectedMonth: month,
        selectedDay:   day
      });
    }
  }

  render() {
    return(
      <>
        <HeadNav />
        <Container className={ this.props.classes.container }>
          <div className={ this.props.classes.tweetListContainer }>
            { this.state.tweets.length <= 0 ? <LinearProgress /> : <TweetList tweets={ this.state.tweets } /> }
          </div>
          { this.state.dates.length > 0 && <DateSelectors { ...this.selectedDate() } dates={ this.state.dates } selectedDateUpdater= { this.onSelectedDateChange.bind(this) } /> }
        </Container>
      </>
    );
  }

  selectedDate() {
    return { selectedYear: this.state.selectedYear, selectedMonth: this.state.selectedMonth, selectedDay: this.state.selectedDay };
  }

  onSelectedDateChange(year, month, day) {
    const params = { year: year, month: month, day: day };
    axios.get(`${apiOrigin}/statuses`, { params: params })
      .then( response => response.data )
      .then( tweets => this.setState({ tweets: tweets }) )
      .then( () =>{
        const path = [year, month, day].filter(function(e){return e}).join("/");
        this.props.history.push(`/public_timeline/${path}`);
    });
  }
}

export default withRouter(withStyles(styles)(PublicTimeline));

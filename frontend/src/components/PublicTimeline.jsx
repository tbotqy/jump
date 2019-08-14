import React from "react";
import {
  Container,
  LinearProgress
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import axios from "axios";

import HeadNav       from "./HeadNav";
import DateSelectors from "./timeline/DateSelectors";
import TweetList     from "./TweetList";

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
    this.state = {
      dates:  [],
      tweets: []
    };
  }

  componentDidMount() {
    fetch("http://localhost:3000/tweeted_dates")
      .then( response => response.json() )
      .then( json => {
        this.setState({ dates: json });
      });

    fetch("http://localhost:3000/statuses")
      .then( response => response.json() )
      .then( json => {
        this.setState({ tweets: json });
      });
  }

  render() {
    return(
      <>
        <HeadNav />
        <Container className={ this.props.classes.container }>
          <div className={ this.props.classes.tweetListContainer }>
            { this.state.tweets.length <= 0 ? <LinearProgress /> : <TweetList tweets={ this.state.tweets } /> }
          </div>
          { this.state.dates.length > 0 && <DateSelectors dates={ this.state.dates } selectedDateUpdater= { this.onSelectedDateChange.bind(this) } /> }
        </Container>
      </>
    );
  }

  onSelectedDateChange(year, month, day) {
    const params = { year: year, month: month, day: day };
    axios.get("http://localhost:3000/statuses", { params: params })
      .then( response => response.data )
      .then ( tweets => this.setState({ tweets: tweets }) );
  }
}

export default withStyles(styles)(PublicTimeline);

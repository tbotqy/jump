import React          from "react";
import { Container }  from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";

import HeadNav       from "./HeadNav";
import DateSelectors from "./timeline/DateSelectors";
import TweetList     from "./TweetList";

const styles = theme => ({
  container: {
    paddingTop:   theme.spacing(3),
    paddingLeft:  theme.spacing(1),
    paddingRight: theme.spacing(1)
  }
});

class PublicTimeline extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      dates:  [],
      tweets: [],
      datesLoaded: false
    };
  }

  UNSAFE_componentWillMount() {
    fetch("http://localhost:3000/tweeted_dates")
      .then( response => response.json() )
      .then( json => {
        this.setState({ dates: json, datesLoaded: true });
      });
  }

  render() {
    return(
      <>
        <HeadNav />
        <Container className={ this.props.classes.container }>
          <TweetList tweets={ this.state.tweets } />
          { this.state.datesLoaded && <DateSelectors dates={ this.state.dates } /> }
        </Container>
      </>
    );
  }
}

export default withStyles(styles)(PublicTimeline);

import React from "react";
import {
  Grid,
  Container,
  List,
  ListItem,
  ListSubheader
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import HeadNav from "./HeadNav";
import TweetCard from "./TweetCard";
import Selector from "./timeline/Selector";

const styles = theme => ({
  container: {
    paddingTop:   theme.spacing(3),
    paddingLeft:  theme.spacing(1),
    paddingRight: theme.spacing(1)
  },
  dateSelectorContainer: {
    position: "sticky",
    bottom: theme.spacing(3)
  }
});

class Timeline extends React.Component {
  constructor(props) {
    super(props);
    this.classes = this.props.classes;
    this.state = {
      year: 2019,
      month: "",
      day: ""
    };
    this.initData();
  }

  render() {
    return (
      <React.Fragment>
        <HeadNav />
        <Container className={ this.classes.container }>
          <Grid container justify="center">
            <Grid item lg={ 8 }>
              <List subheader={ <ListSubheader disableSticky>2019年8月10日頃のあなたのツイート</ListSubheader> }>
                { this.tweets.map((tweet, index) => (
                  <ListItem divider disableGutters key={ index }>
                    <TweetCard key={ index } tweet={ tweet } />
                  </ListItem>
                )) }
              </List>
            </Grid>
          </Grid>

          <Grid container justify="flex-end" spacing={ 1 } className={ this.classes.dateSelectorContainer }>
            <Grid item>
              <Selector selections={ this.years } initialValue={ 2019 } disableNullValue />
            </Grid>
            <Grid item>
              <Selector selections={ this.months } initialValue={ null } />
            </Grid>
            <Grid item>
              <Selector selections={ this.days } initialValue={ null } />
            </Grid>
          </Grid>
        </Container>
      </React.Fragment>
    );
  }

  initData() {
    this.years = [ 2019, 2018, 2017, 2016, 2015, 2014, 2013 ];
    this.months = [ 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1 ];
    this.days = [
      31,
      30,
      29,
      28,
      27,
      26,
      25,
      24,
      23,
      22,
      21,
      20,
      19,
      18,
      17,
      16,
      15,
      14,
      13,
      12,
      11,
      10,
      9,
      8,
      7,
      6,
      5,
      4,
      3,
      2,
      1
    ];

    this.tweets = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ].map(n => {
      return {
        id: "1122892466170896390",
        avatarUrl:
          "https://pbs.twimg.com/profile_images/2447778203/rad31469gu8q3161ad40_bigger.jpeg",
        screenName: "twit_jump",
        name: "twitjump.me",
        content: `これは${n}ツイートです。これはツイートです。これはツイートです。これはツイートです。これはツイートです。これはツイートです。これはツイートです。これはツイートです。これはツイートです。`,
        tweetedAt: "20:49 - 2019年5月12日",
        entity: "pic.twitter.com/foo/bar"
      };
    });
  }
}

export default withStyles(styles)(Timeline);

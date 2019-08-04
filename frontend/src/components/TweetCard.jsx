import React from "react";
import {
  Grid,
  Typography,
  Avatar,
  Card,
  CardHeader,
  CardContent,
  CardActions,
  IconButton,
  Link
} from "@material-ui/core";
import {
  Reply,
  Repeat,
  Favorite
} from "@material-ui/icons";
import { withStyles } from "@material-ui/core/styles";
import TwitterLogo from "./../assets/twitter/logo.svg";

const styles = (theme) => ({
  logo: {
    marginTop: theme.spacing(1)
  },
  tweetedAt: {
    padding: "0 12px",
    color: "grey"
  }
});


class TweetCard extends React.Component {
  render() {
    return (
      <Card elevation={ 0 }>
        <CardHeader
          avatar={
            <IconButton href="https://twitter.com/TwitterJP" target="_blank">
              <Avatar src={ this.props.tweet.avatarUrl } />
            </IconButton>
          }
          title={
            <Link
              color="inherit"
              href="https://twitter.com/TwitterJP"
              target="_blank"
            >
              { this.props.tweet.name }
            </Link>
          }
          subheader={
            <Link
              color="inherit"
              href="https://twitter.com/TwitterJP"
              target="_blank"
            >{ `@${this.props.tweet.screenName}` }</Link>
          }
          action={
            <IconButton disabled>
              <Avatar className={ this.props.classes.logo } src={ TwitterLogo } />
            </IconButton>
          }
        />

        <CardContent>
          <Typography component="p">{ this.props.tweet.content }</Typography>
        </CardContent>

        <CardActions>
          <Grid container justify="space-between" alignItems="center">
            <Grid item>
              <IconButton
                href={ `https://twitter.com/intent/tweet?in_reply_to=${this.props.tweet.id}` }
              >
                <Reply fontSize="small" />
              </IconButton>
              <IconButton
                href={ `https://twitter.com/intent/retweet?tweet_id=${this.props.tweet.id}` }
              >
                <Repeat fontSize="small" />
              </IconButton>
              <IconButton
                href={ `https://twitter.com/intent/like?tweet_id=${this.props.tweet.id}` }
              >
                <Favorite fontSize="small" />
              </IconButton>
            </Grid>
            <Grid item className={ this.props.classes.tweetedAt }>
              <Link
                color="inherit"
                href="https://twitter.com/TwitterJP/status/1126748214210646018"
                target="_blank"
              >
                { this.props.tweet.tweetedAt }
              </Link>
            </Grid>
          </Grid>
        </CardActions>
      </Card>
    );
  }
}

export default withStyles(styles)(TweetCard);

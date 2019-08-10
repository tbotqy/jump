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
  card: {
    flexGrow: 1
  },
  logo: {
    marginTop: theme.spacing(1)
  },
  tweetedAt: {
    padding: "0 12px",
    color: "grey"
  }
});


function TweetCard(props) {
  return (
    <Card elevation={ 0 } className={ props.classes.card } >
      <CardHeader
        avatar={
          <IconButton href={ `https://twitter.com/${props.tweet.user.screen_name}` } target="_blank">
            <Avatar src={ props.tweet.user.avatar_url } />
          </IconButton>
        }
        title={
          <Link
            color="inherit"
            href={ `https://twitter.com/${props.tweet.user.screen_name}` }
            target="_blank"
          >
            { props.tweet.name }
          </Link>
        }
        subheader={
          <Link
            color="inherit"
            href={ `https://twitter.com/${props.tweet.user.screen_name}` }
            target="_blank"
          >{ `@${props.tweet.user.screen_name}` }</Link>
        }
        action={
          <IconButton disabled>
            <Avatar className={ props.classes.logo } src={ TwitterLogo } />
          </IconButton>
        }
      />

      <CardContent>
        <Typography component="p">{ props.tweet.text }</Typography>
      </CardContent>

      <CardActions>
        <Grid container justify="space-between" alignItems="center">
          <Grid item>
            <IconButton
              href={ `https://twitter.com/intent/tweet?in_reply_to=${props.tweet.tweet_id}` }
            >
              <Reply fontSize="small" />
            </IconButton>
            <IconButton
              href={ `https://twitter.com/intent/retweet?tweet_id=${props.tweet.tweet_id}` }
            >
              <Repeat fontSize="small" />
            </IconButton>
            <IconButton
              href={ `https://twitter.com/intent/like?tweet_id=${props.tweet.tweet_id}` }
            >
              <Favorite fontSize="small" />
            </IconButton>
          </Grid>
          <Grid item className={ props.classes.tweetedAt }>
            <Link
              color="inherit"
              href={ `https://twitter.com/${props.tweet.user.screen_name}/status/${props.tweet.tweet_id}` }
              target="_blank"
            >
              { props.tweet.tweeted_at }
            </Link>
          </Grid>
        </Grid>
      </CardActions>
    </Card>
  );

}

export default withStyles(styles)(TweetCard);

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
  Link,
  Theme,
  createStyles,
  WithStyles
} from "@material-ui/core";
import {
  Reply,
  Repeat,
  Favorite
} from "@material-ui/icons";
import { withStyles } from "@material-ui/core/styles";
import formatDateString from "../utils/formatDateString";
import linkifyTweetText from "../utils/linkifyTweetText";
import TwitterIcon from "./TwitterIcon";
import {
  TweetUser,
  UrlEntity
} from "../api";

const styles = (theme: Theme) => (
  createStyles({
    card: {
      flexGrow: 1
    },
    retweetIcon : {
      paddingTop: theme.spacing(1.7)
    },
    tweetText: {
      wordBreak: "break-all"
    },
    tweetTextWrapper: {
      whiteSpace: "pre-line"
    },
    logo: {
      marginTop:   theme.spacing(3),
      marginRight: theme.spacing(2)
    },
    tweetedAt: {
      padding: "0 12px",
      color: "grey"
    }
  })
);

interface Props extends WithStyles<typeof styles> {
  isRetweet: boolean;
  tweetId: string;
  name: string;
  screenName: string;
  avatarUrl: string;
  text: string;
  tweetedAt: string;
  user: TweetUser;
  urlEntities: UrlEntity[];
}

const TweetCard: React.FC<Props> = props => {
  const classes    = props.classes;

  const isRetweet  = props.isRetweet;
  const tweetId    = props.tweetId;
  const name       = props.name;
  const screenName = props.screenName;
  const avatarUrl  = props.avatarUrl;
  const text       = linkifyTweetText(props.text, props.urlEntities);
  const tweetedAt  = formatDateString(props.tweetedAt);
  const user       = props.user;

  return (
    <Card elevation={ 0 } className={ classes.card } >
      { isRetweet &&
        <Typography variant="caption" color="textSecondary">
          <Repeat className={ classes.retweetIcon } />{ user.name }がリツイート
        </Typography>
      }
      <CardHeader
        avatar={
          <IconButton href={ `https://twitter.com/${screenName}` } target="_blank">
            <Avatar src={ avatarUrl } />
          </IconButton>
        }
        title={
          <Link
            color="inherit"
            href={ `https://twitter.com/${screenName}` }
            target="_blank"
          >
            { name }
          </Link>
        }
        subheader={
          <Link
            color="inherit"
            href={ `https://twitter.com/${screenName}` }
            target="_blank"
          >{ `@${screenName}` }</Link>
        }
        action={ <TwitterIcon className={ classes.logo } /> }
      />

      <CardContent>
        <Typography component="p" className={ classes.tweetText }>
          <span className={ classes.tweetTextWrapper } dangerouslySetInnerHTML={ { __html: text } } />
        </Typography>
      </CardContent>

      <CardActions>
        <Grid container justify="space-between" alignItems="center">
          <Grid item>
            <IconButton
              href={ `https://twitter.com/intent/tweet?in_reply_to=${tweetId}` }
            >
              <Reply fontSize="small" />
            </IconButton>
            <IconButton
              href={ `https://twitter.com/intent/retweet?tweet_id=${tweetId}` }
            >
              <Repeat fontSize="small" />
            </IconButton>
            <IconButton
              href={ `https://twitter.com/intent/like?tweet_id=${tweetId}` }
            >
              <Favorite fontSize="small" />
            </IconButton>
          </Grid>
          <Grid item className={ classes.tweetedAt }>
            <Link
              color="inherit"
              href={ `https://twitter.com/${user.screenName}/status/${tweetId}` }
              target="_blank"
            >
              { isRetweet ? `${tweetedAt} にリツイート` : tweetedAt }
            </Link>
          </Grid>
        </Grid>
      </CardActions>
    </Card>
  );
};

export default withStyles(styles)(TweetCard);

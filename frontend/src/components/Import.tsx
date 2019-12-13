import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  Grid,
  Typography,
  Button,
  LinearProgress,
  CircularProgress,
  Fade,
  Theme,
  createStyles,
  WithStyles
} from "@material-ui/core";
import clsx from "clsx";
import TweetEmbed from "react-tweet-embed";
import {
  requestInitialTweetImport,
  requestFolloweeImport,
  fetchImportProgress,
  API_ERROR_CODE_NOT_FOUND,
  API_ERROR_CODE_TOO_MANY_REQUESTS
} from "../utils/api";
import { PAGE_TITLE_IMPORT } from "../utils/pageHead";
import { USER_TIMELINE_PATH } from "../utils/paths";
import green from "@material-ui/core/colors/green";
import CheckIcon from "@material-ui/icons/Check";
import HeadAppBar from "./HeadAppBar";
import UserMenu from "../containers/UserMenuContainer";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";
import Head from "./Head";
import { User } from "../models/user";

const styles = (theme: Theme) => (
  createStyles({
    gridContainerWrapper: {
      padding:   theme.spacing(3),
      marginTop: theme.spacing(4)
    },
    progressContainer: {
      width: "100%"
    },
    buttonWrapper: {
      position: "relative"
    },
    circularProgress: {
      position: "absolute",
      top: "6px",
      left: "20px"
    },
    buttonSuccess: {
      backgroundColor: green[500],
      "&:hover": {
        backgroundColor: green[700],
      }
    },
    checkIcon: {
      marginRight: theme.spacing(1)
    },
    tweetWrapper: {
      width: "100%"
    }
  })
);

interface Props extends WithStyles<typeof styles> {
  user?: User;
  setApiErrorCode: (code: number) => void;
}

interface State {
  lastTweetId?:    string;
  isInProgress:    boolean;
  hasFinished:     boolean;
  showProgressBar: boolean;
  progress:        number;
  showTweet:       boolean;
}

class Import extends React.Component<Props, State> {
  state = {
    lastTweetId:     undefined,
    isInProgress:    false,
    hasFinished:     false,
    showProgressBar: false,
    progress:        0,
    showTweet:       false
  };

  render() {
    return (
      <>
        <Head title={ PAGE_TITLE_IMPORT } />
        <HeadAppBar>
          <UserMenu hideLinkToData />
        </HeadAppBar>
        <div className={ this.props.classes.gridContainerWrapper }>
          <ApiErrorBoundary>
            <Grid container direction="column" alignItems="center" spacing={ 6 }>
              <Grid item>
                { this.props.user && <Typography variant="h5" component="h1">@{ this.props.user.screen_name } のツイートを取り込む</Typography> }
              </Grid>
              <Grid item>
                <div className={ this.props.classes.buttonWrapper }>
                  <Button
                    variant="contained"
                    color="primary"
                    disabled={ this.state.isInProgress }
                    onClick={ this.handleClick.bind(this) }
                    className={ clsx({ [this.props.classes.buttonSuccess]: this.state.hasFinished }) }
                  >
                    { this.state.hasFinished ? <><CheckIcon className={ this.props.classes.checkIcon } /> 完了! リダイレクトします ...</> : "開始" }
                  </Button>
                  { this.state.isInProgress && <CircularProgress size={ 24 } className={ this.props.classes.circularProgress } /> }
                </div>
              </Grid>
              <Grid item className={ this.props.classes.progressContainer }>
                { this.state.showProgressBar && <LinearProgress variant="determinate" value={ this.state.progress } /> }
              </Grid>
              <Fade in={ this.state.showTweet }>
                <Grid item className={ this.props.classes.tweetWrapper }>
                  { this.state.lastTweetId && <TweetEmbed id={ this.state.lastTweetId || "" } options={ { align: "center" } } /> }
                </Grid>
              </Fade>
            </Grid>
          </ApiErrorBoundary>
        </div>
      </>
    );
  }

  async handleClick() {
    if ( this.state.isInProgress || this.state.hasFinished ) return;
    this.setState({ isInProgress: true });

    // kick the import jobs on the server
    try {
      await requestFolloweeImport();
    } catch(error) {
      return this.props.setApiErrorCode(error.response.status);
    }

    try {
      await requestInitialTweetImport();
    } catch(error) {
      if(error.response.status === API_ERROR_CODE_TOO_MANY_REQUESTS) {
        // A job is already kicked working.
        // Do nothing.
      } else {
        return this.props.setApiErrorCode(error.response.status);
      }
    }

    this.setState({ showProgressBar: true });
    // check for the import progress once per 2 seconds.
    const progressCheckInterval = 2000;
    const interval: NodeJS.Timeout = setInterval(() => this.checkProgress(interval), progressCheckInterval);
  }

  async checkProgress(interval: NodeJS.Timeout) {
    const redirectInterval = 3000;

    this.setState({ showTweet: false });
    try {
      const response = await fetchImportProgress();
      const progress = response.data;
      if(progress.finished) {
        clearInterval(interval);
        this.setState({
          isInProgress: false,
          hasFinished:  true,
          progress:     100,
          lastTweetId:  progress.last_tweet_id,
          showTweet:    true
        });
        setTimeout( () => { document.location.href = USER_TIMELINE_PATH; }, redirectInterval );
      } else {
        this.setState({
          progress:    progress.percentage,
          lastTweetId: progress.last_tweet_id,
          showTweet:   true
        });
      }
    } catch(error) {
      if( error.response.status !== API_ERROR_CODE_NOT_FOUND ) {
        clearInterval(interval);
        this.setState({ isInProgress: false });
        this.props.setApiErrorCode(error.response.status);
      }
    }
  }
}

export default withStyles(styles)(Import);

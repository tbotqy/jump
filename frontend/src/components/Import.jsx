import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  Grid,
  Typography,
  Button,
  LinearProgress,
  CircularProgress,
  Fade
} from "@material-ui/core";
import clsx from "clsx";
import TweetEmbed from "react-tweet-embed";
import api, { API_ERROR_CODE_TOO_MANY_REQUESTS } from "../utils/api";
import { USER_TIMELINE_PATH } from "../utils/paths";
import getUserIdFromCookie from "../utils/getUserIdFromCookie.js";
import green from "@material-ui/core/colors/green";
import CheckIcon from "@material-ui/icons/Check";
import HeadAppBar from "./HeadAppBar";
import UserMenu from "../containers/userMenuContainer";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";

const styles = theme => ({
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
});

class Import extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isInProgress:    false,
      hasFinished:     false,
      showProgressBar: false,
      progress:        0,
      showTweet:       false
    };
  }

  render() {
    return (
      <React.Fragment>
        <HeadAppBar>
          <UserMenu user={ this.props.user } hideLinkToData />
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
                  { this.state.last_tweet_id && <TweetEmbed id={ this.state.last_tweet_id } options={ { align: "center" } } /> }
                </Grid>
              </Fade>
            </Grid>
          </ApiErrorBoundary>
        </div>
      </React.Fragment>
    );
  }

  handleClick() {
    if ( this.state.isInProgress || this.state.hasFinished ) return;

    // kick the import job on the server
    this.requestImport()
      .catch( error => {
        if(error.response.status === API_ERROR_CODE_TOO_MANY_REQUESTS) {
          // A job is already kicked working.
          // Do nothing.
          return true;
        }else{
          this.props.setApiErrorCode(error.response.status);
          return false;
        }
      }).then( continueFlag => {
        if(!continueFlag) return;

        this.setState({
          isInProgress:    true,
          showProgressBar: true
        });

        // check for the import progress once per 2 seconds.
        const redirectInterval      = 3000;
        const progressCheckInterval = 2000;
        const interval = setInterval( () => {
          this.setState({ showTweet: false });
          this.fetchImportProgress()
            .then( response => {
              const progress = response.data;
              if(progress.finished) {
                clearInterval(interval);
                this.setState({
                  isInProgress:  false,
                  hasFinished:   true,
                  progress:      progress.percentage,
                  last_tweet_id: progress.last_tweet_id,
                  showTweet:     true
                });
                setTimeout( () => { document.location.href = USER_TIMELINE_PATH; }, redirectInterval );
              }else{
                this.setState({
                  progress:      progress.percentage,
                  last_tweet_id: progress.last_tweet_id,
                  showTweet:     true
                });
              }
            }).catch( error => {
              if( error.response.status !== 404 ) {
                clearInterval(interval);
                this.setState({ isInProgress: false });
                this.props.setApiErrorCode(error.response.status);
              }
            });
        }, progressCheckInterval );
      });
  }

  requestImport() {
    const userId = getUserIdFromCookie();
    return api.post(`/users/${userId}/statuses`);
  }

  fetchImportProgress() {
    const userId = getUserIdFromCookie();
    return api.get(`/users/${userId}/tweet_import_progress`);
  }
}

export default withStyles(styles)(Import);

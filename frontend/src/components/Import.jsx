import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  Grid,
  Typography,
  Button,
  LinearProgress,
  CircularProgress
} from "@material-ui/core";
import clsx from "clsx";
import TweetEmbed from "react-tweet-embed";
import api, { API_ERROR_CODE_TOO_MANY_REQUESTS } from "../utils/api";
import { USER_TIMELINE_PATH } from "../utils/paths";
import getUserIdFromCookie from "../utils/getUserIdFromCookie.js";
import green from "@material-ui/core/colors/green";
import CheckIcon from "@material-ui/icons/Check";
import HeadAppBar from "./HeadAppBar";
import UserMenu from "./head_nav/UserMenu";
import Footer from "./Footer";
import ErrorMessage from "./ErrorMessage";

const styles = theme => ({
  container: {
    padding: "24px"
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
    minHeight: "500px"
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
      apiErrorCode:    null
    };
  }

  componentDidMount() {
    this.props.fetchUser()
      .then( response => this.props.setUser(response.data) )
      .catch( error => this.props.setApiErrorCode(error.response.status) );
  }

  render() {
    return (
      <React.Fragment>
        <HeadAppBar>
          { this.props.user && <UserMenu user={ this.props.user } hideLinkToData /> }
        </HeadAppBar>
        {
          this.state.apiErrorCode ? (
            <ErrorMessage apiErrorCode={ this.state.apiErrorCode } />
          ) : (
            <Grid container direction="column" alignItems="center" spacing={ 6 } className={ this.props.classes.container } >
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
              <Grid item className={ this.props.classes.tweetWrapper }>
                { this.state.last_tweet_id && <TweetEmbed id={ this.state.last_tweet_id } /> }
              </Grid>
            </Grid>
          )
        }
        <Footer bgCaramel />
      </React.Fragment>
    );
  }

  handleClick() {
    if ( this.state.isInProgress || this.state.hasFinished ) return;

    // kick the import job on the server
    this.requestImport();

    this.setState({
      isInProgress:    true,
      showProgressBar: true
    });

    // check for the import progress once per 2 seconds.
    const interval = setInterval( () => {
      this.fetchImportProgress()
        .then( response => {
          const progress = response.data;
          if(progress.finished) {
            clearInterval(interval);
            this.setState({
              isInProgress:  false,
              hasFinished:   true,
              progress:      progress.percentage,
              last_tweet_id: progress.last_tweet_id
            });
            setTimeout( () => { document.location.href = USER_TIMELINE_PATH; }, 3000 );
          }else{
            this.setState({
              progress:      progress.percentage,
              last_tweet_id: progress.last_tweet_id
            });
          }
        }).catch( error => {
          clearInterval(interval);
          this.setState({
            isInProgress: false,
            apiErrorCode: error.response.status
          });
        });
    }, 2000 );
  }

  requestImport() {
    const userId = getUserIdFromCookie();
    api.post(`/users/${userId}/statuses`)
      .catch( error => {
        if(!error.response) return console.log(error);
        if(error.response.status === API_ERROR_CODE_TOO_MANY_REQUESTS) {
          // A job is already kicked working.
          // Do nothing.
        }else{
          this.setState({
            apiErrorCode: error.response.status
          });
        }
      });
  }

  fetchImportProgress() {
    const userId = getUserIdFromCookie();
    return api.get(`/users/${userId}/tweet_import_progress`);
  }
}

export default withStyles(styles)(Import);

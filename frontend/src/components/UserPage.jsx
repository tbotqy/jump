import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  fetchUserByScreenName,
  fetchUserTweets,
  fetchUserSelectableDates
} from "../utils/api";
import timelineTitleText from "../utils/timelineTitleText";
import Timeline from "../containers/TimelineContainer";
import Head from "./Head";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";
import HeadNav from "../containers/HeadNavContainer";
import UserProfile from "../components/UserProfile";
import FullPageLoading from "./FullPageLoading";
import Footer from "./Footer";
import {
  Container,
  Grid,
  Typography
} from "@material-ui/core";

const styles = theme => ({
  profileContainer: {
    paddingTop: theme.spacing(2.5)
  },
  message: {
    paddingTop: theme.spacing(10),
    minHeight: "50vh"
  }
});

// to be passed to the child
const tweetsFetchFunc = userId => (year, month, day, page) => (
  fetchUserTweets(year, month, day, page, userId)
);

class UserPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      currentUser: null,
      showMessage: false
    };
  }

  async componentDidMount() {
    this.props.setSelectableDates([]);
    const { screenName, year, month, day } = this.props.match.params;

    try {
      const response = await fetchUserByScreenName(screenName);
      const currentUser = response.data;
      this.setState({ currentUser });

      const userId = currentUser.id;
      this.fetchTweets(userId, year, month, day);
      this.fetchSelectableDates(userId, year, month, day);
    } catch (error) {
      this.props.setApiErrorCode(error.response.status);
    }
  }

  render() {
    return(
      <>
        <Head title={ this.title() } />
        <HeadNav />
        <ApiErrorBoundary>
          <Container className={ this.props.classes.profileContainer }>
            { this.state.currentUser &&
              <Grid container justify="center">
                <Grid item xs={ 12 } md={ 9 }  >
                  <UserProfile { ...this.state.currentUser } />
                </Grid>
              </Grid>
            }
          </Container>
          { !this.state.currentUser ?
            <FullPageLoading />
            : !this.state.showMessage ?
              <Timeline tweetsFetchFunc={ tweetsFetchFunc(this.state.currentUser.id).bind(this) } />
              : (
              <>
                <Grid container direction="column" alignItems="center" className={ this.props.classes.message }>
                  <Grid item>
                    <Typography variant="h4" component="h1" color="textSecondary">{ this.state.message }</Typography>
                  </Grid>
                </Grid>
                <Footer />
              </>
              )
          }
        </ApiErrorBoundary>
      </>
    );
  }

  async fetchTweets(userId, year, month, day) {
    this.props.setIsFetching(true);
    try {
      const response = await fetchUserTweets(year, month, day, 1, userId);
      this.props.setTweets(response.data);
    } catch(error) {
      this.handleTweetDataApiError(error);
    } finally {
      this.props.setIsFetching(false);
    }
  }

  async fetchSelectableDates(userId) {
    try {
      const response = await fetchUserSelectableDates(userId);
      this.props.setSelectableDates(response.data);
    } catch(error) {
      this.handleTweetDataApiError(error);
    }
  }

  title() {
    const { screenName, year, month, day } = this.props.match.params;
    const name = this.state.currentUser ? this.state.currentUser.name : "";
    return timelineTitleText(`${name}（@${screenName}）の過去のツイート`, year, month, day);
  }

  handleTweetDataApiError(error) {
    switch(error.response.status) {
    case 400:
    case 401:
      this.setState({ showMessage: true, message: "非公開ユーザーです" });
      break;
    case 404:
      this.setState({ showMessage: true, message: "ツイートが未登録です" });
      break;
    default:
      this.props.setApiErrorCode(error.response.status);
      break;
    }
  }
}

export default withStyles(styles)(UserPage);

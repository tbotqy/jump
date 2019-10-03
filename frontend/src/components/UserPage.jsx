import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  fetchUserByScreenName,
  fetchUserTweets,
  fetchUserSelectableDates,
  API_ERROR_CODE_BAD_REQUEST,
  API_ERROR_CODE_UNAUTHORIZED,
  API_ERROR_CODE_NOT_FOUND
} from "../utils/api";
import timelineTitleText from "../utils/timelineTitleText";
import Timeline from "../containers/TimelineContainer";
import Head from "./Head";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";
import HeadNav from "../containers/HeadNavContainer";
import HeadProgressBar from "../containers/HeadProgressBarContainer";
import UserProfile from "../components/UserProfile";
import DateSelectors from "../containers/DateSelectorsContainer";
import FullPageLoading from "./FullPageLoading";
import Footer from "./Footer";
import {
  Container,
  Grid,
  Typography,
  Box
} from "@material-ui/core";

const styles = theme => ({
  container: {
    paddingTop:   theme.spacing(3),
    paddingLeft:  theme.spacing(2),
    paddingRight: theme.spacing(2)
  },
  message: {
    paddingTop: theme.spacing(10),
    minHeight: "50vh"
  },
  dateSelectorContainer: {
    position: "sticky",
    bottom: theme.spacing(3)
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
      showMessage: false,
      selectableDates: []
    };
  }

  async componentDidMount() {
    this.setState({ selectableDates: [] });
    const { screenName, year, month, day } = this.props.match.params;

    try {
      const response = await fetchUserByScreenName(screenName);
      const currentUser = response.data;
      this.setState({ currentUser });

      const userId = currentUser.id;
      this.fetchTweets(userId, year, month, day);
      this.fetchSelectableDates(userId);
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
          <HeadProgressBar />
          {
            !this.state.currentUser? (
              <FullPageLoading />
            ) : (
              <>
                <Container maxWidth="md" className={ this.props.classes.container }>
                  <UserProfile { ...this.state.currentUser } />
                  { this.state.showMessage ?
                    this.errorMessage() :
                    <Box pt={ 3 }>
                      <Timeline tweetsFetchFunc={ tweetsFetchFunc(this.state.currentUser.id) } />
                    </Box>
                  }
                </Container>
                { this.state.selectableDates.length > 0 &&
                  <Box pr={ 2 } className={ this.props.classes.dateSelectorContainer }>
                    <DateSelectors
                      selectableDates={ this.state.selectableDates }
                      onSelectionChangeTweetsFetchFunc={ tweetsFetchFunc(this.state.currentUser.id) }
                    />
                  </Box>
                }
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
      this.setState({ selectableDates: response.data });
    } catch(error) {
      this.handleTweetDataApiError(error);
    }
  }

  title() {
    const { screenName, year, month, day } = this.props.match.params;
    const userName = this.state.currentUser ? `${this.state.currentUser.name}（@${screenName}）` : `@${screenName}`;
    return timelineTitleText(`${userName}の過去のツイート`, year, month, day);
  }

  handleTweetDataApiError(error) {
    switch(error.response.status) {
    case API_ERROR_CODE_BAD_REQUEST:
    case API_ERROR_CODE_UNAUTHORIZED:
      this.setState({ showMessage: true, message: "非公開ユーザーです" });
      break;
    case API_ERROR_CODE_NOT_FOUND:
      this.setState({ showMessage: true, message: "ツイートが未登録です" });
      break;
    default:
      this.props.setApiErrorCode(error.response.status);
      break;
    }
  }

  errorMessage() {
    return(
      <>
        <Grid container item justify="center" className={ this.props.classes.message }>
          <Typography variant="h4" component="p" color="textSecondary">{ this.state.message }</Typography>
        </Grid>
        <Footer />
      </>
    );
  }
}

export default withStyles(styles)(UserPage);
